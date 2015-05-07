## Book Nuke'm

The intent here is to provide a script to programmatically view and especially **delete** anything
from your Facebook account.

I'm finding viewing to be relatively straightforward.  I'm finding deleting much of shit to be exceedingly difficult.

As of right now this is more of an experiment than anything.

###

Intended usage:

 - go to https://developers.facebook.com/tools/explorer/ and generate an API key
 - stick that key in `~/.facebook.yml` as the value of the key `access_token:`, e.g.:

``` yaml
access_token: FOOBAR_123456_SOMETHINGSOMETHING
```

 - **DON'T** check that `~/.facebook.yml` file into version control (especially a public repository anywhere), unless you want really bad things to happen to your facebook account.
 - `bundle install --path vendor`
 - `bundle exec ruby bin/explore.rb --help`

###

 Resources (i.e., things I go back to and re-read while trying to figure this out):

 - http://stackoverflow.com/questions/20662145/use-facebook-graphapi-or-fql-to-get-facebook-activity-log
 - https://github.com/mcls/fql
 - https://developers.facebook.com/docs/reference/opengraph
 - https://developers.facebook.com/tools/explorer
 - https://github.com/arsduo/koala/wiki/Graph-API
 - http://www.shoutmeloud.com/how-to-acquire-your-facebook-api-key.html
 - https://developers.facebook.com/apps/390975564421093/settings/
 - https://github.com/arsduo/koala/blob/master/lib/koala/api/graph_api.rb#L308-L312
 - https://github.com/arsduo/koala
