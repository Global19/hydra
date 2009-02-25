package Hydra::Base::Controller::Nix;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Hydra::Helper::Nix;
use Hydra::Helper::CatalystUtils;


sub closure : Chained('nix') PathPart {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'Hydra::View::NixClosure';

    # !!! quick hack; this is to make HEAD requests return the right
    # MIME type.  This is set in the view as well, but the view isn't
    # called for HEAD requests.  There should be a cleaner solution...
    $c->response->content_type('application/x-nix-export');
}


sub manifest : Chained('nix') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{current_view} = 'Hydra::View::NixManifest';
    $c->stash->{narBase} = $c->uri_for($self->action_for("nar"), $c->req->captures);
}


sub nar : Chained('nix') PathPart {
    my ($self, $c, @rest) = @_;

    my $path .= "/" . join("/", @rest);

    error($c, "Path " . $path . " is no longer available.") unless isValidPath($path);

    # !!! check that $path is in the closure of $c->stash->{storePaths}.

    $c->stash->{current_view} = 'Hydra::View::NixNAR';
    $c->stash->{storePath} = $path;
}


1;
