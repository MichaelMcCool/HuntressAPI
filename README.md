# HuntressAPI
A PS module for working with the Huntress Platform API

This is very much a work in progress. I've yet to add help documentation, and I'm still working on a few cmdlets. The Get-HuntressRemediation cmdlet is still unfinished. I'm trying to use ValidateSet where possible to make sure that supplied values are correct, but the way the API works in some situations makes it difficult to implement.

My first goal in all of this is to get all of the read-only API calls working properly and only then start adding write functions.

Quick Start:

import-module HuntressAPI

Set-HuntressKey '\<key\>'

Set-HuntressSecret '\<secret\>'


Get-HuntressOrganiation



Please note that there is a bug currently in the Huntress API when filtering the agent by platform when more than one page of results are present. The module uses a page size of 50, so this bug is expressed when over 50 results are in the query response. Filtering by 'darwin','windows', or 'linux' will only function properly when the results are 50 or fewer. This bug has been reported to Huntress.
