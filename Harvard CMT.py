# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <markdowncell>

# we use [urllib.urlretrieve](http://docs.python.org/2/library/urllib.html#urllib.urlretrieve) to save the contents at the url in to the file.

# <codecell>

import urllib

url= 'http://www.ldeo.columbia.edu/~gcmt/projects/CMT/catalog/jan76_dec10.ndk.gz'
urllib.urlretrieve(url, 'jan76_dec10.ndk.gz')

