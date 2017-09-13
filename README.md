# .emacs.d
After getting fed up with vimscript being utter s#!%, I decided it was time for a change of pace. This "emacs" thing that I had heard people talking about seemed to have some pretty avid followers, and I was a fan of scheme in the past so I thought elisp couldn't be that hard (ha). While the switch was a pain, I couldn't be happier at this point. My insane quest for a text editor customized to my liking to be as fast to use as possible is resulting in a truely evil emacs configuration, drawing a fair bit of inspiration from [spacemacs](http://www.spacemacs.org) and my [old vimrc](https://github.com/YourFin/dotfiles/blob/master/.vimrc). 

## A few of my oddities worth mentioning
I type with a [dvorak keyboard layout](https://www.google.com/search?q=dvorak+keyboard). Would I say that this was a wise switch from qwerty? No, I would not; all I've gained as far as I can tell is neckbeard cred and a poor anti-theft mechanism. However, I'm too far gone at this point to relearn all my muscle memory, so I'm sticking with it. As such some keybindings may be awkward given their apparent usage frequency, however they mostly stick to vim defaults.

The way that vim (and evil mode) handle the clipboard by default infuriates me; I only want the damn thing to change when I explicitly say so. As such, `m` has been rebound to `d` but actually interacts with the clipboard, and all other keys that result in deletion dump to the second spot in the kill ring. 

I use helm. I should probably try ivy one of these days given all the hype it gets, but I haven't gotten around to it yet.

As a vim expat, I am not typically a fan of using my mouse to run around my text editor; as such, my emacs config is designed to be entirely keyboard driven.

I typically am running emacs on half of a [13 inch](https://www.notebookcheck.net/Dell-XPS-13-9350-InfinityEdge-Ultrabook-Review.153376.0.html) screen next to firefox, and as such space is very much at a premium; some design descions may reflect this. 
