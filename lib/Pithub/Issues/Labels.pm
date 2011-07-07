package Pithub::Issues::Labels;

# ABSTRACT: Github v3 Issue Labels API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=method add

=over

=item *

Add labels to an issue

    POST /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->add(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => ['Label1', 'Label2'],
    );

=back

=cut

sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}

=method create

=over

=item *

Create a label

    POST /repos/:user/:repo/labels

Examples:

    $result = $p->issues->labels->create(
        repo => 'Pithub',
        user => 'plu',
        data => {
            color => 'FFFFFF',
            name  => 'some label',
        }
    );

=back

=cut

sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( POST => sprintf( '/repos/%s/%s/labels', $args{user}, $args{repo} ), $args{data} );
}

=method delete

=over

=item *

Delete a label

    DELETE /repos/:user/:repo/labels/:id

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        label => 1,
    );

=back

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label' unless $args{label};
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/repos/%s/%s/labels/%s', $args{user}, $args{repo}, $args{label} ) );
}

=method get

=over

=item *

Get a single label

    GET /repos/:user/:repo/labels/:id

Examples:

    $result = $p->issues->labels->get(
        repo => 'Pithub',
        user => 'plu',
        label => 1,
    );

=back

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label' unless $args{label};
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/labels/%s', $args{user}, $args{repo}, $args{label} ) );
}

=method list

=over

=item *

List all labels for this repository

    GET /repos/:user/:repo/labels

Examples:

    $result = $p->issues->labels->list(
        repo => 'Pithub',
        user => 'plu'
    );

=item *

List labels on an issue

    GET /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->list(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=item *

Get labels for every issue in a milestone

    GET /repos/:user/:repo/milestones/:id/labels

Examples:

    $result = $p->issues->labels->get(
        repo         => 'Pithub',
        user         => 'plu',
        milestone_id => 1
    );

=back

=cut

sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    if ( my $milestone_id = $args{milestone_id} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/milestones/%s/labels', $args{user}, $args{repo}, $milestone_id ) );
    }
    elsif ( my $issue_id = $args{issue_id} ) {
        return $self->request( GET => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $issue_id ) );
    }
    return $self->request( GET => sprintf( '/repos/%s/%s/labels', $args{user}, $args{repo} ) );
}

=method remove

=over

=item *

Remove a label from an issue

    DELETE /repos/:user/:repo/issues/:id/labels/:id

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        label => 1,
    );

=item *

Remove all labels from an issue

    DELETE /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->delete(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
    );

=back

=cut

sub remove {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    if ( my $label = $args{label} ) {
        return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/%s/labels/%s', $args{user}, $args{repo}, $args{issue_id}, $label ) );
    }
    return $self->request( DELETE => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $args{issue_id} ) );
}

=method replace

=over

=item *

Replace all labels for an issue

    PUT /repos/:user/:repo/issues/:id/labels

Examples:

    $result = $p->issues->labels->replace(
        repo     => 'Pithub',
        user     => 'plu',
        issue_id => 1,
        data     => [qw(label3 label4)],
    );

=back

=cut

sub replace {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: issue_id' unless $args{issue_id};
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/repos/%s/%s/issues/%s/labels', $args{user}, $args{repo}, $args{issue_id} ), $args{data} );
}

=method update

=over

=item *

Update a label

    PATCH /repos/:user/:repo/labels/:id

Examples:

    $result = $p->issues->labels->update(
        repo     => 'Pithub',
        user     => 'plu',
        label => 1,
        data     => {
            color => 'FFFFFF',
            name  => 'API',
        }
    );

=back

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: label' unless $args{label};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request( PATCH => sprintf( '/repos/%s/%s/labels/%s', $args{user}, $args{repo}, $args{label} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
