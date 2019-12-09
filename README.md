# SideChannelMatlab
This is a set of Matlab/Octave scripts to perform side channel analysis on crypto systems. There are scripts for Differential Power Analysis and Differential Computational Analysis both in single bit and multi-bit(hamming Weight) versions.

The development log and usage examples are available at:

https://www.janbeck.com/cybersecurity-challenges-ctfs-and-more/differential-power-analysis-on-aes-hands-on-single-bit-attack

https://www.janbeck.com/cybersecurity-challenges-ctfs-and-more/differential-power-analysis-on-aes-hands-on-multi-bit-attack

https://www.janbeck.com/cybersecurity-challenges-ctfs-and-more/attacks-on-white-box-crypto-hands-on-single-bit-attack

https://www.janbeck.com/cybersecurity-challenges-ctfs-and-more/attacks-on-white-box-crypto-hands-on-multi-bit-attack

The name of this project is a bit of a tongue-in-cheek reference to the SideChannelMarvels tools available here:
https://github.com/SideChannelMarvels

The goal of these scripts is to keep them as concise and simple as possible in order to
- Allow for the usage in academic settings
- Make it easy to implement changes to try out variations

Thus, they are easy to understand and change but not optimized for speed. If you need that, go to SideChannelMarvels. The scripts are all attacking AES SBOXes, but their simplicity makes it easy to adjust for other attacks and cryptosystems.

DPA.m is a single-bit differential power analysis attack. It is a modified version of a script provided by Florent Bruguier as in support of the book "Differential power analysis, advances in cryptology – crypto 1999 , Kocher, P., Jaffe, J. and Jun, B. (1999) ‘ LNCS 1666, pp.388–397, Springer-Verlag.". The files plaintext-00112233445566778899aabbccddeeff.txt and traces-00112233445566778899aabbccddeeff.bin are also from there.

PAHammingCorrelation.m is a multi-bit (one byte) power analysis attack. It uses a Hamming Weight model with a Pearson Correlation. It uses the same data set at DPA.m for comparability, but can be easily adjusted for new data.
