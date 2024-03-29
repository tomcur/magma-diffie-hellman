# Diffie-Hellman on finite cyclic groups
This program implements Diffie-Hellman on finite cyclic groups in Magma, a computer algebra programming language.
Two implementations of such groups are provided: modular exponential groups and subgroups of elliptic curves.
Elliptic curve cyclic subgroups are provided using both Magma's implementation as well as a (naive) custom implementation.

## What is implemented?

| Path | Description |
| ---- | ----------- |
| `./DiffieHellman/lib.m` | A generic implementation of Diffie-Hellman on finite cyclic groups. |
| `./EllipticCurve/lib.m` | An implementation of cryptographic elliptic curves using Magma's built-in curves. It supports curves of the form `y^2 + a_1 xy + a_3 y = x^3 + a_2 x^2 + a_4 x + a_6`. It explicitly implements such curves as cyclic groups, and provides some security utilities (such as parameter validation). |
| `./EllipticCurve/parameters.m` | Some example curves (Curve25519 and P-192). |
| `./EllipticCurve/secrets.m` | A specialized implementation of the Diffie-Hellman protocol using only elliptic curves. It's no longer necessary, given `./DiffieHellman/lib.m` is more generic, but is kept for example purposes. |
| `./ModularExponential/lib.m` | An implementation of modular exponential groups. It explicitly implements such groups as cyclic groups, and provide a security utility for parameter validation. |
| `./ModularExponential/parameters.m` | Some example modular exponential groups (a 64-bit MODP group and a real-world 2048-bit MODP group). |
| `./MyEllipticCurve/curve_impl.m` | A custom implementation of elliptic curves. It supports curves of the form `y^2 = x^3 + a_4 x + a_6`. |
| `./MyEllipticCurve/lib.m` | An implementation of cryptographic elliptic curves using a custom implementation of curves. It explicitly implements such curves as cyclic groups. |
| `./MyEllipticCurve/parameters.m` | An example curve (P-192). |
| `./main.m` | An example of a full Diffie-Hellman key exchange on a finite cyclic group. |
| `./test.m` | Various tests and a benchmark. |

## Parameter sources

* The 2048-bit MODP group is taken from [RFC 3526 Section 3](https://tools.ietf.org/html/rfc3526#section-3);
* The cryptographic elliptic curve P-192 is taken from [FIPS 186-4 D.1.2](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf); and
* The cryptographic elliptic curve Curve25519 is taken from [Daniel J. Bernstein's Curve25519: new Diffie-Hellman speed records](https://cr.yp.to/ecdh/curve25519-20060209.pdf).

## Limitations

* This Diffie-Hellman implementation does not have a final key-derivation step and the resulting shared secret is simply an element of the chosen finite cyclic group.
* This Diffie-Hellman implementation does not check for validity of public keys.
From the finite cyclic groups provided, elliptic curves are especially vulnerable to invalid public keys, as in general the subgroup generated can have lower order than the group of points on the curve itself.
* In general it might be necessary to take special care when generating secret keys.
This is the case for e.g. Curve25519, where the set of secret keys is smaller than the subgroup order to prevent some timing attacks and other leaks.
This implementation does not account for that.
