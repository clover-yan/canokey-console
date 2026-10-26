# Please use the official CanoKey Console

My pull request has been merged and the changes are now live in the official CanoKey Console. For your safety and security, please use the official CanoKey Console at <https://console.canokeys.org> instead.

This repository is only preserved for further possible contributions to the official CanoKey Console.

Thank you for your attention to this matter!

&mdash; Clover Yan

> [!NOTE]
> 
> Here is a reference of how to deploy your own CanoKey Console to Cloudflare Pages:
> 
> Build command: `echo 'Downloading Flutter' && curl -sSf https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.2-stable.tar.xz | tar xJ -C "$HOME" && echo 'Installing Rust' && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && echo 'Setting up environment' && export PATH="$PATH:$HOME/flutter/bin:$HOME/.cargo/bin" && echo 'Installing Rust dependencies' && cargo install flutter_rust_bridge_codegen cargo-bundle-licenses wasm-pack && echo 'Getting Flutter packages' && flutter pub get && echo 'Adding Rust source component' && rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu && echo 'Building web target' && flutter_rust_bridge_codegen build-web --release && echo 'Building Flutter web app' && flutter build web --release`\
> Build output: `build/web`\
> Root directory: (none)
