---
title: Install local web server
description: In this step you learn how to install a local web server for testing purposes.
---

# Install local web server

Install a web server, such as `http-server`, on your local machine for testing purposes, using a command such as the following:

``` shell
npm install http-server -g
```

You can then run the server locally in your project directory with:

``` shell
http-server -c-1
```

The `-c-1` option prevents caching by the web server.
