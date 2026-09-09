% octave_smoke.m — Octave-compatible mirror of tests/NDcell2matTest.m.
% matlab.unittest is unavailable in Octave, so this script re-implements
% the same 11 cases with plain assert() calls. Run: octave --eval "tests/octave_smoke"
% or: octave tests/octave_smoke.m
% Verified passing under GNU Octave 11.3.0 (2026-09-08).

addpath(fileparts(fileparts(mfilename('fullpath'))));
n_pass = 0;
n_total = 0;

function ok = check(name, fn)
    try
        fn();
        printf('PASS: %s\n', name);
        ok = true;
    catch err
        printf('FAIL: %s -- %s\n', name, err.message);
        ok = false;
    end
end

function msg = errmsg_of(fn)
    msg = '';
    try
        fn();
    catch err
        msg = err.message;
    end
end

n_total++; n_pass += check('1D column, default NaN filler', @() ...
    assert(isequaln(NDcell2mat({[1;2]; [3]; [4;5;6]}), ...
        [1, 2, NaN; 3, NaN, NaN; 4, 5, 6])));

n_total++; n_pass += check('2D cell, explicit Inf filler', @() ...
    assert(isequal(NDcell2mat({[1, 2], [10]; [3], [20, 30]}, Inf), ...
        cat(3, [1 10; 3 20], [2 Inf; Inf 30]))));

n_total++; n_pass += check('3D cell, new trailing dim', @() ...
    assert(isequal(size(NDcell2mat(reshape( ...
        {[1, 2], [3]; [4, 5], [6, 7, 8]}, [2, 2, 1]))), [2 2 3])));

n_total++; n_pass += check('default filler is NaN', @() ...
    assert(isnan(NDcell2mat({[1;2]; [3]})(2, 2))));

n_total++; n_pass += check('custom filler -99', @() ...
    assert(NDcell2mat({[1;2]; [3]}, -99)(2, 2) == -99));

n_total++; n_pass += check('scalar-only equals cell2mat', @() ...
    assert(isequal(NDcell2mat({5; 10; 15}), cell2mat({5; 10; 15}))));

n_total++; n_pass += check('empty numeric content -> filler row', @() ...
    assert(all(isnan(NDcell2mat({[1;2]; []; [3;4;5]})(2, 1:3)))));

n_total++; n_pass += check('non-numeric content errors', @() ...
    assert(numel(strfind(errmsg_of(@() NDcell2mat({'hello'})), 'non-numeric')) > 0));

n_total++; n_pass += check('char filler warns and converts', @() ...
    assert(isequaln(NDcell2mat({[1;2]; [3]}, 'NaN'), NDcell2mat({[1;2]; [3]}))));

n_total++; n_pass += check('empty cell C={} errors', @() ...
    assert(~isempty(errmsg_of(@() NDcell2mat({})))));

n_total++; n_pass += check('logical content errors', @() ...
    assert(~isempty(errmsg_of(@() NDcell2mat({[true, false]; [true]})))));

printf('\n%d/%d passed\n', n_pass, n_total);
if n_pass ~= n_total
    error('octave_smoke: %d failure(s)', n_total - n_pass);
end
