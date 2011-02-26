use strict;
use warnings;
use Test::More;
use Test::Requires 'Text::MicroTemplate::File';
use File::Spec;
use File::Temp qw/tempdir/;
use Plack::Response;

my $tmp = tempdir(CLEANUP => 1);

{
    package MyApp;
    use parent qw/Amon2/;

    package MyApp::Web;
    use parent -norequire, qw/MyApp/;
    use parent qw/Amon2::Web/;
    use Tiffany::Text::Xslate;
    {
	my $view = Tiffany::Text::Xslate->new(+{
	   'path'      => [$tmp],
	   'syntax'    => 'TTerse',
	   'module'    => [ 'Text::Xslate::Bridge::TT2Like' ],
	   function    => {
	        c => sub { Amon2->context() },
 	   },
	});
	sub create_view { $view }
    }
    sub dispatch {
    	my $c = shift;
	$c->render('hoge.mt');
    }
    __PACKAGE__->load_plugins('Web::TweetButton');
}


my $c = MyApp::Web->bootstrap();

{
    open my $fh, '>', File::Spec->catfile($tmp, 'hoge.mt') or die $!;
    print $fh <<'...';
[% c().tweet_button() | raw %]

[% c().tweet_button({ count => 'horizontal' }) | raw %]

[% c().tweet_button({ count => 'none' }) | raw %]

[% c().tweet_button({ text => 'Foo' }) | raw %]

[% c().tweet_button({ url => 'http://example.com' }) | raw %]

[% c().tweet_button({ lang => 'ja' }) | raw %]

[% c().tweet_button({ via => 'memememomo' }) | raw %]

[% c().tweet_button({ related => 'memememomo:A bad boy!' }) | raw %]
...
    close $fh;
}


{
    my $res = MyApp::Web->to_app()->(+{});
    my $content = $res->[2]->[0];

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-count="vertical">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-text="Foo" data-count="vertical">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-url="http://example.com" data-count="vertical">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-count="vertical" data-lang="ja">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-count="vertical" data-via="memememomo">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

    like $content, qr(<a href="http://twitter.com/share" class="twitter-share-button" data-count="vertical" data-related="memememomo:A bad boy!">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>);

}

done_testing();
