" vi: fdm=marker

" PlugLazyLoading: {{{
augroup load_us_ycm
    autocmd!
    autocmd InsertEnter *
        \ call plug#load('ultisnips', 'YouCompleteMe', 'auto-pairs')
        \| call youcompleteme#Enable()
        \| call AutoPairsTryInit()
        \| autocmd! load_us_ycm
augroup END
" }}}
" Oblique: {{{
autocmd! User Oblique
autocmd! User ObliqueStar
autocmd! User ObliqueRepeat

" autocmd User Oblique       normal! zz
" autocmd User ObliqueStar   normal! zz
" autocmd User ObliqueRepeat normal! zz
" }}}
" FileSpecific: {{{
augroup filespecific
    autocmd!
    " autocmd BufRead,BufNewFile *.md set filetype=markdown
    " autocmd FileType sql,php,vim,javascript autocmd BufWritePre <buffer> :%s/\s\+$//e
    " autocmd FileType sql,php,vim,javascript autocmd BufWritePre <buffer> :%s/\t/    /g
    autocmd FileType javascript setlocal omnifunc=syntaxcomplete#Complete
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd FileType gitcommit set cursorline
    " eclim
    " autocmd FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
    " autocmd FileType php nnoremap <silent> <buffer> <cr> :PhpSearchContext<cr>
    autocmd FileType html.twig setlocal commentstring={#%s#}
augroup END
" }}}
" BufNewFile: {{{
autocmd BufRead *.php call InsertTempateIfEmpty()
" autocmd BufNewFile,BufRead *.php call InsertTempateIfEmpty()
function! InsertTempateIfEmpty()
    if @% == ""
        " No filename for current buffer
        so ~/dotfiles/vim/template/php.vim
    elseif filereadable(@%) == 0
        " File doesn't exist yet
        so ~/dotfiles/vim/template/php.vim
    elseif line('$') == 1 && col('$') == 1
        " File is empty
        so ~/dotfiles/vim/template/php.vim
    endif
endfunction
" }}}
" TmuxMargin: {{{
let g:shouldTryToCreateTmuxMargin = 1
function! TryToCreateTmuxMargin()
    let g:shouldTryToCreateTmuxMargin = 0
    if !TmuxHasMargin()
        call TmuxMarginInit(120)
    endif
endfunction

autocmd VimEnter * if g:shouldTryToCreateTmuxMargin | call TryToCreateTmuxMargin() | endif
" }}}

