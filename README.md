# wack - Wallet Ack

Inspired by Ack, this is wallet ack (wack). It can read any Bitcoin
(or compatible fork) wallet.dat file and tell you lots of stuff about it,
allow you to search it, perform forensic analysis on corrupt files and
various other things.

Here is a typical Zcash fork wallet.dat :

    $ ./wack
    =====Wallet Key Stats=====
    tx                        4379
    keymeta                   181
    key                       181
    pool                      101
    name                      97
    purpose                   97
    watchs                    66
    zkeymeta                  25
    zkey                      25
    version                   1
    orderposnext              1
    minversion                1
    defaultkey                1
    bestblock                 1
    witnesscachesize          1
    Total: 5158 keys in 15 key types

This particular wallet came from a Hush 2.0 node, which can be inferred because
64 of the watch-only addresses correspond to 2018 Komodo notary addresses.

# CLI Arguments

By default, wack reads a wallet.dat in the current directory. To specify a different
location, give it as an argument. For example, the default location of a Zcash wallet
on OS X:

    ./wack ~/Library/Application\ Support/Zcash/wallet.dat

# Security

Never show the output of this program to anyone, unless you know exactly what it means!

This program has read-only access to the wallet it opens, the code cannot write
to the wallet.dat in any way. In fact, the Perl library we use does not support
writing to the kind of BerkeleyDB format wallet.dat is in, our library limits
us to read-only access.

You should read and understand every line in wack before you run it on a wallet
that has any value.

# Compatible Coins

  * Bitcoin
  * Zcash
  * Komodo + all asset chains
  * Hush
  * Any codebase which uses BTC wallet.dat format

Currently Monero/CryptoNite wallets are not supported, but that feature may
be implemented in the future. Patches welcome!

# License

GPLv3
