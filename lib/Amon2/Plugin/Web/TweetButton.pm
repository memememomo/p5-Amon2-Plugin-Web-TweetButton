package Amon2::Plugin::Web::TweetButton;
use strict;
use warnings;
use Amon2::Util;
our $VERSION = '0.01';


sub init {
    my ($class, $c, $conf) = @_;

    Amon2::Util::add_method($c, 'tweet_button' => sub {
	my ($c, $stuff) = @_;

	$stuff->{url}     ||= $conf->{url};
	$stuff->{count}   ||= $conf->{count} || 'vertical';
	$stuff->{via}     ||= $conf->{via};
	$stuff->{related} ||= $conf->{related};
	$stuff->{lang}    ||= $conf->{lang};

	my $attrs = '';
	for my $name (qw/url text count via related lang/) {
	    $attrs .= qq/ data-$name="$stuff->{$name}"/ if $stuff->{$name};
	}

	my $tag = <<"EOF";
<a href="http://twitter.com/share" class="twitter-share-button"$attrs>Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
EOF
        $tag;
    });
}


1;
__END__

=head1 NAME

Amon2::Plugin::Web::TweetButton - TweetButton Helper Plugin

=head1 SYNOPSIS

  package MyApp::Web;
  use base qw/MyApp Amon2::Web/;

  __PACKAGE__->load_plugins('Web::TweetButton' => {
    lang => 'ja',
  });

=haed1 NOTE

THIS IS ALPHA QUALITY CODE!

If you found bug, please report by e-mail or twitter(@memememomo).

=head1 DESCRIPTION

L<Amon2::Plugin::Web::TweetButton> adds a C<tweet_button> helper.
It is compatible with the button described on twitter page L<http://twitter.com/goodies/tweetbutton>.

=head2 Helper

  [% c().tweet_button() %]

Generate tweet button.

=head2 Arguments

All the arguments can be set globally (when loading a plugin) or locally (in the template).

=over 4

=item count

  [% c().tweet_button({ count => 'horizontal' }) %]

Location of the tweet count box (can be "vertical", "horizontal" or "none"; "vertical" by default).

=item url

  [% c().tweet_button({ url => 'http://example.com' }) %]

The URL you are sharing (HTTP Referrer by default).

=item text

  [% c().tweet_button({ url => 'Wow!' }) %]

The text that will appear in the tweet (Content of the <title> tag by default).

=item via

  [% c().tweet_button({ via => 'memememomo' }) %]

The author of the tweet (no default).

=item related

  [% c().tweet_button({ related => 'memememomo:A robot' }) %]

Related twitter accounts (no default).

=item lang

  [% c().tweet_button({ lang => 'ja' }) %]

The language of the tweet (no default).

=back

=head1 AUTHOR

memememomo E<lt>memememmomo@gmail.comE<gt>


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
