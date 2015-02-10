## Technical Summary

IndiePants is an open-source, distributed social network and personal
publishing system that is powered by simple, open protocols.

### Glossary

- [IndiePants]: this project.
- [IndieWeb]: a user-driven initiative to build an alternative to the walled-garden corporate web.
- [Webmention]: a simple protocol for notifying a URL that you're linking to it.
- [Microformats2]: a collection of simple markup protocols to add structure to data represented as HTML.
- Document/Post: something you're publishing on the web.
- Comment: a document commenting on another document.
- Like: an expression of approval, as seen on Facebook et al.
- Following: a user you're following.
- Follower: a user who's following you.

### Documents

The basic building block of IndiePants is a `Document`. Each IndiePants
stores a multitude of these documents in its database, both created by
the users hosted by the node, but also pulled from other IndiePants
nodes (or non-IndiePants websites.)

A document essentially represents a web document and primarily consists of
a `url` and an `html` body. These URLs can be locally hosted, but they can also
be URLs on remote servers; there are many scenarios in which IndiePants will
pull a copy of a remote document. More on that later.

The base class, `Document`, has a number of subclasses that add functionality.
The most obvious one is `Pants::Post`, which implements a Markdown-formatted
blog post published in your IndiePants instance. There are also `Pants::Like`
and `Pants::Repost` which describe the social interactions they're named after.
(For example, a "Like" on the IndiePants Network is actually an HTML document
that is published to the web; once again, more on that later.)

The `html` attribute is common to all document types; the various different
classes mostly implement code that eventually renders HTML (and saves it in `html`.)
This structure allows IndiePants nodes to receive documents from other nodes
even if they don't have the code for the document type available.


### URL Handling

Each document has one, and only one, URL, which is unique within the local node's
database. If the document describes a remote web document which, at some point,
is moved to a new URL, and IndiePants notices a 301 redirect, the URL in the database
will be updated to reflect this change.

Documents keep an array of `previous_urls`, but mostly for introspection reasons
(and so IndiePants can serve 301 redirects for old URLs, too.)


### Links

Documents on the web are often linked to each other. This can happen in a multitude
of ways; a web page may contain a simple link to another URL, or it could
use metadata like [microformats2] to describe a specific relationship to another
document on the web.

These links are stored in the IndiePants database as
`Link` instances; locally created documents (like blog posts linking to other documents)
will update this list of links directly, while remotely fetched, non-IndiePants
documents will have their HTML parsed for links.

This is how IndiePants maintains a healthy amount of compatibility with non-IndiePants
sites as long as they're implementing simple, well-documented standards like
microformats2.

Typically, once a locally created document links to another, non-local document,
a [Webmention] is sent to the target document to notify it of this link. It is then
assumed that the target document's server will fetch the source document you created
to properly parse it for links.

This works both ways; when IndiePants receives a Webmention from a remote host,
the referenced source document is copied into the local database and analyzed for links.

When a local document is being rendered, the generated HTML representation will
include this list of links (both linked to by it, and linking to it.) This is how
IndiePants is able to render Comments, Likes and more.


### Posting new Documents

Posting a new document on your IndiePants node mostly revolves around filling in
a form provided by the chosen document type, and then letting it render its own
representation into the `html` attribute. From this point forward, the new
document is accessible on the web, both as HTML as well as a structured JSON document
that may be used by other IndiePants nodes to copy them into their own databases.


### Commenting

There is no special "comment" document type; in IndiePants (and the IndieWeb
in general), any document can be a comment on another document simply by linking
to it, using the `u-in-reply-to` class.


### Likes

Just like anything else going on in IndiePants, a Like is just a document of the
`Pants::Like` type, referencing the URL of the document that was liked, no matter
if local or remote, IndiePants-based or not.

The HTML rendered by this document includes a link with the `u-like-of` class,
and the referenced document is once again notified via [Webmention]. It is then
up to the liked document's server to either parse and list the Like, or
ignore it.


### Reposts

_TODO_

### Following other users

IndiePants allows you to follow other users (to automatically receive their own
posts and read them in an aggregated timeline, just like on Twitter or Facebook.)

The interesting thing here is that you can not only follow other IndiePants users,
but _any_ user on the web, _as long_ as they have an IndieWeb-compatible web
presence; ie., they are running on their own, exclusive domain.

IndiePants stores your followings in a separate database table and publishes them
on a separate, publicly available page on your IndiePants site. This page lists
your followings as simple HTML links using a `rel="following"` attribute, allowing
other sites to verify in a very simple manner that you're following them.

When someone follows you using IndiePants, your site will also receive a Webmention,
notifying you of this. This webmention request will list the Followings page
described above as its source document and your domain's root path as its target;
your IndiePants instance will now fetch the other user's Followings page to verify
that they're following you, and store this information in its local database
(mostly in order to show you who's following you, but also for optimization purposes.)


### Pulling your followings' posts

With the mechanism described above, your IndiePants will build a list of users
(IndieWeb domains) that you're subscribing to. The challenge here is that not all
of these users may be running IndiePants themselves, so if we want to poll
one of these users for updates, we need a cascading mechanism that tries a couple
of things in order of IndiePants' own preference.

First, IndiePants will parse the other user's HTML in order to do a bit of feature
discovery. If it sees that the other user is using IndiePants, too, it will simply
use IndiePants' JSON feed of documents.

If the JSON feed can't be found, it will look for an ATOM or RSS feed to consume.

If even that fails, it will look for a [`h-feed`](http://microformats.org/wiki/h-feed),
or any collection of `h-entry` elements.


-- Hendrik Mans, hendrik@mans.de

[Webmention]: http://webmention.org
[microformats2]: http://microformats.org/wiki/microformats2
[IndiePants]: https://github.com/hmans/indiepants
[IndieWeb]: http://indiewebcamp.com/
