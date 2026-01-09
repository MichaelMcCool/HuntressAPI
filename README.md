# HuntressAPI
A PS module for working with the Huntress Platform API

This is very much a work in progress. I've yet to add help documentation, and I'm still working on a few cmdlets. The Get-HuntressRemediation cmdlet is still unfinished. I'm trying to use ValidateSet where possible to make sure that supplied values are correct, but the way the API works in some situations makes it difficult to implement.

My first goal in all of this is to get all of the read-only API calls working properly and only then start adding write functions.

Quick Start:

import-module HuntressAPI

Set-HuntressKey '\<key\>'

Set-HuntressSecret '\<secret\>'


Get-HuntressOrganiation
