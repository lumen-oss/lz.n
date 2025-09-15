# Changelog

## [2.12.1](https://github.com/lumen-oss/lz.n/compare/v2.12.0...v2.12.1) (2025-09-13)


### Bug Fixes

* experimental support for `vim.pack` ([457c58e](https://github.com/lumen-oss/lz.n/commit/457c58e938be1db85a7d9c20c2caeb996efbbdbf))

## [2.12.0](https://github.com/lumen-oss/lz.n/compare/v2.11.4...v2.12.0) (2025-08-23)


### Features

* experimental support for `vim.pack` ([#175](https://github.com/lumen-oss/lz.n/issues/175)) ([1271a0f](https://github.com/lumen-oss/lz.n/commit/1271a0f54525236f7d43fb26608151c171c0e456))

## [2.11.4](https://github.com/lumen-oss/lz.n/compare/v2.11.3...v2.11.4) (2025-07-14)


### Bug Fixes

* **rockspec:** restrict lua version to 5.1 ([bad1ae6](https://github.com/lumen-oss/lz.n/commit/bad1ae6f540d5fed64cd488042858cc70538c867))

## [2.11.3](https://github.com/lumen-oss/lz.n/compare/v2.11.2...v2.11.3) (2025-06-26)


### Bug Fixes

* **keys:** error when specifying filetype pattern ([#163](https://github.com/lumen-oss/lz.n/issues/163)) ([518dcf4](https://github.com/lumen-oss/lz.n/commit/518dcf474d6588c2830c6a85442ce1f57c0208b3))

## [2.11.2](https://github.com/lumen-oss/lz.n/compare/v2.11.1...v2.11.2) (2025-02-08)


### Bug Fixes

* don't propagate startup plugin loading errors ([#137](https://github.com/lumen-oss/lz.n/issues/137)) ([4b64680](https://github.com/lumen-oss/lz.n/commit/4b64680e8df6529a66925ee11ea2e0d1c0b7b06a))

## [2.11.1](https://github.com/lumen-oss/lz.n/compare/v2.11.0...v2.11.1) (2025-01-26)


### Performance Improvements

* **keymap-api:** cache lookups ([2817538](https://github.com/lumen-oss/lz.n/commit/281753820ff91ff6897c21e8b8d493c2b7740961))

## [2.11.0](https://github.com/lumen-oss/lz.n/compare/v2.10.1...v2.11.0) (2025-01-26)


### Features

* `keymap(<plugin>).set` lazy-loading API ([#133](https://github.com/lumen-oss/lz.n/issues/133)) ([36aec13](https://github.com/lumen-oss/lz.n/commit/36aec13b46e9cc784d0e5346302cc222155f98f9))

## [2.10.1](https://github.com/lumen-oss/lz.n/compare/v2.10.0...v2.10.1) (2025-01-25)


### Bug Fixes

* cmd handler can delete user commands created in before hook ([#130](https://github.com/lumen-oss/lz.n/issues/130)) ([448df14](https://github.com/lumen-oss/lz.n/commit/448df14ce9adb29eff9903e89e19d1497b8cc429))

## [2.10.0](https://github.com/lumen-oss/lz.n/compare/v2.9.2...v2.10.0) (2025-01-01)


### Features

* support explicit `lazy=false` ([#122](https://github.com/lumen-oss/lz.n/issues/122)) ([5a6d5fa](https://github.com/lumen-oss/lz.n/commit/5a6d5fa243cd9010d610daa7b9a111f56687a605))

## [2.9.2](https://github.com/lumen-oss/lz.n/compare/v2.9.1...v2.9.2) (2024-10-30)


### Bug Fixes

* **loader:** support importing submodules (`foo.bar`) ([988b7b3](https://github.com/lumen-oss/lz.n/commit/988b7b3c9a55deae5dcf229edb146b61589395dc))

## [2.9.1](https://github.com/lumen-oss/lz.n/compare/v2.9.0...v2.9.1) (2024-10-24)


### Bug Fixes

* setting `lazy = false` marks plugin as eager ([#108](https://github.com/lumen-oss/lz.n/issues/108)) ([6325a21](https://github.com/lumen-oss/lz.n/commit/6325a21905419c43152e4c91315f98b05d67663d))

## [2.9.0](https://github.com/lumen-oss/lz.n/compare/v2.8.1...v2.9.0) (2024-10-21)


### Features

* `lazy` field for lazy-loading via `trigger_load` only ([#105](https://github.com/lumen-oss/lz.n/issues/105)) ([a7b445f](https://github.com/lumen-oss/lz.n/commit/a7b445fd34fb242f7fa5d294499e89f55ed0935a))

## [2.8.1](https://github.com/lumen-oss/lz.n/compare/v2.8.0...v2.8.1) (2024-10-15)


### Bug Fixes

* **hooks:** regression preventing beforeAll from being run ([#101](https://github.com/lumen-oss/lz.n/issues/101)) ([8259302](https://github.com/lumen-oss/lz.n/commit/82593022086138822245706ed5466ef9bc4e2c7b))

## [2.8.0](https://github.com/lumen-oss/lz.n/compare/v2.7.0...v2.8.0) (2024-09-18)


### Features

* **`load`:** take first module when multiple matches exist on the rtp ([#94](https://github.com/lumen-oss/lz.n/issues/94)) ([1d1c546](https://github.com/lumen-oss/lz.n/commit/1d1c5468f7f87bd800e707f1f537da65d299058a))

## [2.7.0](https://github.com/lumen-oss/lz.n/compare/v2.6.1...v2.7.0) (2024-09-16)


### Features

* move handler field parsing logic to handlers ([#92](https://github.com/lumen-oss/lz.n/issues/92)) ([33796ea](https://github.com/lumen-oss/lz.n/commit/33796eae1d810c28475a8d8e69e9c906fa855703))

## [2.6.1](https://github.com/lumen-oss/lz.n/compare/v2.6.0...v2.6.1) (2024-08-31)


### Bug Fixes

* error when applying colorscheme in after hook on event trigger ([#86](https://github.com/lumen-oss/lz.n/issues/86)) ([bc619dd](https://github.com/lumen-oss/lz.n/commit/bc619dd3b1acee9a13268acb7c49878ce8e8bda5))

## [2.6.0](https://github.com/lumen-oss/lz.n/compare/v2.5.2...v2.6.0) (2024-08-30)


### Features

* **api:** `handler.post_load` for setting up custom events ([#82](https://github.com/lumen-oss/lz.n/issues/82)) ([ed9b8a4](https://github.com/lumen-oss/lz.n/commit/ed9b8a4a1c9add4a46da241a41ac3349531c3dbc))

## [2.5.2](https://github.com/lumen-oss/lz.n/compare/v2.5.1...v2.5.2) (2024-08-28)


### Bug Fixes

* **vimdoc:** missing lz.n.State field ([a1d34cd](https://github.com/lumen-oss/lz.n/commit/a1d34cdf78c9c82bdaf35bb306c70c95575b1d01))

## [2.5.1](https://github.com/lumen-oss/lz.n/compare/v2.5.0...v2.5.1) (2024-08-28)


### Bug Fixes

* **vimdoc:** duplicate tag ([ef2194d](https://github.com/lumen-oss/lz.n/commit/ef2194d277da3707074c7754aa3928ca74638169))

## [2.5.0](https://github.com/lumen-oss/lz.n/compare/v2.4.0...v2.5.0) (2024-08-28)


### Features

* support a simplified handler.state API without keys ([180eb92](https://github.com/lumen-oss/lz.n/commit/180eb920f0e32ccf76db4cc84d36ef4a18e41769))

## [2.4.0](https://github.com/lumen-oss/lz.n/compare/v2.3.0...v2.4.0) (2024-08-28)


### Features

* deprecate trigger_load with lists of plugin specs ([8611566](https://github.com/lumen-oss/lz.n/commit/8611566831f9f0da68b51ca8c5274049d2928265))
* handler.state module ([efe92fa](https://github.com/lumen-oss/lz.n/commit/efe92fa725afcd8ac02b97866f7f41cba0d21a4f))


### Bug Fixes

* handler resilience against trigger_load calls in hooks ([163b247](https://github.com/lumen-oss/lz.n/commit/163b2471e287e3ed9f6ca14ecaaa3e25aeb84c49))
* lookup now returns deep copy ([#74](https://github.com/lumen-oss/lz.n/issues/74)) ([dac14fb](https://github.com/lumen-oss/lz.n/commit/dac14fb5db15c7f3c6a37470e03603cc4601ff60))

## [2.3.0](https://github.com/lumen-oss/lz.n/compare/v2.2.0...v2.3.0) (2024-08-26)


### Features

* vimdoc ([#65](https://github.com/lumen-oss/lz.n/issues/65)) ([c8c06af](https://github.com/lumen-oss/lz.n/commit/c8c06af2ac674d6a77c1c49c89ce2a2220ca3826))

## [2.2.0](https://github.com/lumen-oss/lz.n/compare/v2.1.0...v2.2.0) (2024-08-23)


### Features

* **trigger_load:** return list of skipped plugins instead of failing ([#70](https://github.com/lumen-oss/lz.n/issues/70)) ([9c74d06](https://github.com/lumen-oss/lz.n/commit/9c74d06fdcc1429a07bacc96003bd29b073b53bc))

## [2.1.0](https://github.com/lumen-oss/lz.n/compare/v2.0.1...v2.1.0) (2024-08-22)


### Features

* **api:** ability to filter plugin searches by handlers ([#68](https://github.com/lumen-oss/lz.n/issues/68)) ([33a8b19](https://github.com/lumen-oss/lz.n/commit/33a8b1945c96b10e50de430906973029596805c1))

## [2.0.1](https://github.com/lumen-oss/lz.n/compare/v2.0.0...v2.0.1) (2024-08-22)


### Bug Fixes

* **loader:** deterministic ordering when loading lists of plugins ([8667b60](https://github.com/lumen-oss/lz.n/commit/8667b60015ba0cc67f0a65124755a5911dc1f4b4))

## [2.0.0](https://github.com/lumen-oss/lz.n/compare/v1.4.4...v2.0.0) (2024-08-20)


### ⚠ BREAKING CHANGES

* simplify state management + idempotent `trigger_load` ([#56](https://github.com/lumen-oss/lz.n/issues/56))

### Features

* simplify state management + idempotent `trigger_load` ([#56](https://github.com/lumen-oss/lz.n/issues/56)) ([701d6ac](https://github.com/lumen-oss/lz.n/commit/701d6acc030d1ed6ef16b7efe4d752dbf7d7f13b))


### Bug Fixes

* altered loading order for startup plugins ([#49](https://github.com/lumen-oss/lz.n/issues/49)) ([50c1454](https://github.com/lumen-oss/lz.n/commit/50c145466330c0c5b272fd3904b5655a1613149c))

## [1.4.4](https://github.com/lumen-oss/lz.n/compare/v1.4.3...v1.4.4) (2024-08-09)


### Bug Fixes

* colorscheme handler broken for `start` plugins ([#41](https://github.com/lumen-oss/lz.n/issues/41)) ([7ba8692](https://github.com/lumen-oss/lz.n/commit/7ba8692a5f88c04de5791232887823e0f40f9525))

## [1.4.3](https://github.com/lumen-oss/lz.n/compare/v1.4.2...v1.4.3) (2024-07-10)


### Bug Fixes

* spec list with a single plugin spec ignored ([#34](https://github.com/lumen-oss/lz.n/issues/34)) ([e0831fe](https://github.com/lumen-oss/lz.n/commit/e0831fee3109a56705a6eea896e1d7d5d157a04d))

## [1.4.2](https://github.com/lumen-oss/lz.n/compare/v1.4.1...v1.4.2) (2024-06-29)


### Bug Fixes

* **keys:** don't ignore modes that aren't `'n'` ([#28](https://github.com/lumen-oss/lz.n/issues/28)) ([8886765](https://github.com/lumen-oss/lz.n/commit/8886765a2fcc9b9550dbd2e8d9bb5535f1de290d))

## [1.4.1](https://github.com/lumen-oss/lz.n/compare/v1.4.0...v1.4.1) (2024-06-26)


### Bug Fixes

* odd intermittent issue with load function ([#21](https://github.com/lumen-oss/lz.n/issues/21)) ([1ac92ff](https://github.com/lumen-oss/lz.n/commit/1ac92fff5da1212174956b20383a75b6268c56a7))

## [1.4.0](https://github.com/lumen-oss/lz.n/compare/v1.3.2...v1.4.0) (2024-06-24)


### Features

* extend lz.n with custom handlers ([#17](https://github.com/lumen-oss/lz.n/issues/17)) ([d61186f](https://github.com/lumen-oss/lz.n/commit/d61186fc231797e07986e4dc59f789d8660dc822))

## [1.3.2](https://github.com/lumen-oss/lz.n/compare/v1.3.1...v1.3.2) (2024-06-19)


### Bug Fixes

* **event:** broken `DeferredUIEnter` event ([cf11ec2](https://github.com/lumen-oss/lz.n/commit/cf11ec2b1696dddd5620a055244cc0860f982677))

## [1.3.1](https://github.com/lumen-oss/lz.n/compare/v1.3.0...v1.3.1) (2024-06-19)


### Bug Fixes

* support /nix/store links ([fa625dd](https://github.com/lumen-oss/lz.n/commit/fa625dd86414dc830c6c9b7188fe4cd583e664c4))

## [1.3.0](https://github.com/lumen-oss/lz.n/compare/v1.2.4...v1.3.0) (2024-06-18)


### Features

* support importing `init.lua` submodules ([5c3c2a1](https://github.com/lumen-oss/lz.n/commit/5c3c2a1eb4df0260f9ed738ec321aa85ecf8e0f9))
* support loading plugin spec lists and imports more than once ([d911029](https://github.com/lumen-oss/lz.n/commit/d9110299475823eff784a6ccf6aa3f63dea9b295))

## [1.2.4](https://github.com/lumen-oss/lz.n/compare/v1.2.3...v1.2.4) (2024-06-17)


### Bug Fixes

* actually support importing plugin specs from files ([5553dc5](https://github.com/lumen-oss/lz.n/commit/5553dc52fa696f1e8162329a91e9055ff71020d6))

## [1.2.3](https://github.com/lumen-oss/lz.n/compare/v1.2.2...v1.2.3) (2024-06-16)


### Bug Fixes

* colorscheme lists inserted into wrong table ([9fe735e](https://github.com/lumen-oss/lz.n/commit/9fe735e6ca5e835f953ab284188cd31322804e43))

## [1.2.2](https://github.com/lumen-oss/lz.n/compare/v1.2.1...v1.2.2) (2024-06-16)


### Bug Fixes

* spdx license identifier in release rockspec ([5c71d03](https://github.com/lumen-oss/lz.n/commit/5c71d03bfad28298b1a9cf11f7ce134b5ad6318a))

## [1.2.1](https://github.com/lumen-oss/lz.n/compare/v1.2.0...v1.2.1) (2024-06-16)


### Bug Fixes

* ensure individual plugins can only be registered once ([47a10af](https://github.com/lumen-oss/lz.n/commit/47a10afe2c4eae2d5429864acaba536073f6e089))

## [1.2.0](https://github.com/lumen-oss/lz.n/compare/v1.1.0...v1.2.0) (2024-06-16)


### Features

* register individual plugin specs for lazy loading ([b9c03c1](https://github.com/lumen-oss/lz.n/commit/b9c03c1ed2fd95abd657a7310310aeee039cd3ec))

## [1.1.0](https://github.com/lumen-oss/lz.n/compare/v1.0.0...v1.1.0) (2024-06-15)


### Features

* add `DeferredUIEnter` user event ([0a3b2c5](https://github.com/lumen-oss/lz.n/commit/0a3b2c5e12ced350aec9b6dd797b824e7e34e76a))

## 1.0.0 (2024-06-10)


### Features

* add `before` hook ([19beffc](https://github.com/lumen-oss/lz.n/commit/19beffc4d943aa29fe1edb459833f008d107b9d8))
* add `PluginSpec.config` ([b52a46c](https://github.com/lumen-oss/lz.n/commit/b52a46c624fee24e4ba91a5a29be45c70e45ce5a))
* automatically increase `priority` if `colorscheme` is set ([655ab06](https://github.com/lumen-oss/lz.n/commit/655ab06f4686371f07717c915b16eb4b18f6ef31))
* handler for lazy-loading colorschemes ([d4a2eeb](https://github.com/lumen-oss/lz.n/commit/d4a2eebb84b1c000a8388e167be3cb8f9d1edfe4))
