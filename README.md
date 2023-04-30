# meow-vterm

This package integrates [meow]'s input modes with [vterm]. It makes it so that
in normal mode, all normal bindings apply, and in insert mode, only C-c and ESC
are bound.

`vterm` consumes all inputs other than its exceptions, making it not
integrate well with meow. This package solves this by using a custom keymap
in normal mode with standard bindings, and using the default vterm keymap in
in meow insert mode.

After installing this package, add the following to your init.el:
```elisp
(meow-vterm-enable)
```

Alternatively, to have minimal bindings in insert mode, add the following to
your init.el before vterm is loaded:
```elisp
(setq vterm-keymap-exceptions '("C-c"))
(meow-vterm-enable)
```

[meow]: https://github.com/meow-edit/meow
[vterm]: https://github.com/akermu/emacs-libvterm
