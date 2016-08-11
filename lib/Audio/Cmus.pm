package Audio::Cmus 0.001;

use strict;
use warnings;

use Carp;
use IO::Socket::UNIX;

sub new {

    my ($class, $socket) = @_;

    my $self = bless {} => $class;

    $socket = $socket // "$ENV{HOME}/.cmus/socket";

    if (! -e $socket) {
        carp "Socket file missing (is cmus running?)\n";
        return undef;
    }

    $self->{socket} = IO::Socket::UNIX->new(
        Type => SOCK_STREAM,
        Peer => $socket,
    ) or croak "Error connecting: $@\n";

    return $self;

}

sub _update_state {

    my ($self) = @_;

    return if ($self->{lock} && defined $self->{state});

    my $state;
    my $sock = $self->{socket};
    open my $stream, '-|', 'cmus-remote -Q 2> /dev/null'
        or croak "Error opening cmus-remote stream";
    print {$sock} "status\n";


    while (my $line = <$sock>) {
        chomp $line;
        last if ( length($line) < 1 );
        my ($key, $val) = ($line =~ /^(\w+)\s+(.+)$/);
        die "Error parsing state line" if (! defined $val);
        next if ($key eq 'set');

        if ($key eq 'tag') {
            my ($field, $val) = ($val =~ /^(\w+)\s+(.+)$/);
            # multiple tag instances are legal, so use an array
            push @{ $state->{tags}->{$field} }, $val;
        }
        else {
            $state->{$key} = $val;
        }
    }

    close $stream;

    $self->{state} = $state;

}

sub status {

    my ($self) = @_;
    $self->_update_state;
    return $self->{state}->{status};

}

sub curr_file {

    my ($self) = @_;
    return undef if ($self->status ne 'playing');
    return $self->{state}->{file};

}

sub curr_position {

    my ($self) = @_;
    return undef if ($self->status ne 'playing');
    return $self->{state}->{position};

}

sub curr_duration {

    my ($self) = @_;
    return undef if ($self->status ne 'playing');
    return $self->{state}->{duration};

}

sub curr_tags {

    my ($self) = @_;
    return undef if ($self->status ne 'playing');
    return $self->{state}->{tags};

}

sub lock   { $_[0]->{lock} = 1 }
sub unlock { $_[0]->{lock} = 0 }


1;

__END__

=head1 NAME

Audio::Cmus - interface to the cmus music player

=head1 SYNOPSIS

    use Audio::Cmus;

    my $player = Audio::Cmus->new;

    my $status = $player->status;

=head1 ABSTRACT

This module provides an interface to the C<cmus> music player, provding the means to both query player status (current track, etc) and control playback from within Perl.

=cut

