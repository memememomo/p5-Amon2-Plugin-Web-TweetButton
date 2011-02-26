use inc::Module::Install;
name 'Amon2-Plugin-Web-TweetButton';
all_from 'lib/Amon2/Plugin/Web/TweetButton.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
