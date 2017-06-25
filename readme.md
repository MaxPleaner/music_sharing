## Music sharing

A site to share music with friends.

## What it does right now

It's a work in progress, but I've deployed it as-is.

Right now it just has one capability and that's to show embed for some audio/video
from bandcamp, soundcloud, or youtube. There are different forms and everything
is stored on the server. Editing and deleting is only done through some special commands for now
(I will try and add docs on this at some point in the future)

Auth is disabled, it's all public though the websocket API is still in place
for realtime updates to the embeds list. However in the version I deployed to Github pages (and possibly
the master branch here, I forget), there is a `pass` param which must be sent on the `/` request

_update_ added tags and comments and the ability for anyone to delete anything.

## How it's made

This is made using my [vue-sinatra-boiler](http://github.com/maxpleaner/vua-sinatra-boiler).

## Todos

- add custom file uploads
- add tag filtering
- add auth and shared playlists
