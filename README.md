# Container ffmpeg

Not so much now, but back in the day there were a few issues
building ffmpeg on a mac.

Docker to the rescue! By building inside a container we can enable coolnesses
like openMP by compiling from source inside an ubuntu container.

This is really just an exercise in building things, and as such
isn't being advertised as "hey you should all use this!"

### Why does this exist?

Mainly so I can hone my knowledge and skills around building things
and stripping everything else out to make a tiny tiny tiny image.

This is a work in progress :)

It is entirely based on [this](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu).

The ffmpeg CompilationGuides are awesome. In fact `ffmpeg` is pretty darn awesome.
