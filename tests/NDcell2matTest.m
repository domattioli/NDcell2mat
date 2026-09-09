classdef NDcell2matTest < matlab.unittest.TestCase
    % NDcell2matTest Unit tests for NDcell2mat function
    %
    % Verified passing under GNU Octave 11.3.0 (tests/octave_smoke.m) and
    % under real MATLAB via this repository's CI (matlab-actions/run-tests).
    %
    % Corrections made after real-interpreter verification of a first
    % hand-computed draft: (1) the input-validation `assert` and the
    % filler-coercion `warning` calls in NDcell2mat.m carry no identifier,
    % so those checks are identifier-agnostic; (2) MATLAB/Octave drop a
    % trailing singleton dimension from size(), so a 2x2x3x1 array reports
    % size [2 2 3], not [2 2 3 1]; (3) test_2D_cell_explicit_Inf_filler's
    % expected matrix had C(2,1) and C(1,2) transposed in an earlier draft;
    % (4) the empty-cell case (C={}) errors from a built-in size-vector
    % assignment, not from NDcell2mat.m's own assert(), so its identifier
    % is interpreter/version-dependent and is not checked, only that an
    % error is raised.

    methods(Test)

        function test_1D_column_cell_default_NaN_filler(testCase)
            C = {[1;2]; [3]; [4;5;6]};
            M = NDcell2mat(C);

            expectedM = [
                1, 2, NaN;
                3, NaN, NaN;
                4, 5, 6
            ];

            testCase.verifyEqual(M, expectedM, 'AbsTol', 1e-14);
            testCase.verifyEqual(size(M), [3, 3]);
        end

        function test_2D_cell_explicit_Inf_filler(testCase)
            C = {[1, 2], [10]; [3], [20, 30]};
            M = NDcell2mat(C, Inf);

            % C(1,1)=[1,2], C(2,1)=[3], C(1,2)=[10], C(2,2)=[20,30].
            expectedM = zeros(2, 2, 2) + Inf;
            expectedM(1, 1, 1) = 1;
            expectedM(1, 1, 2) = 2;
            expectedM(2, 1, 1) = 3;
            expectedM(1, 2, 1) = 10;
            expectedM(2, 2, 1) = 20;
            expectedM(2, 2, 2) = 30;

            testCase.verifyEqual(M, expectedM, 'AbsTol', 1e-14);
            testCase.verifyEqual(size(M), [2, 2, 2]);
        end

        function test_3D_cell_no_interior_singleton_dim(testCase)
            % C reshaped to 2x2x1; no interior singleton, so NDcell2mat
            % grows a new trailing dimension sized to the largest cell (3).
            C = {[1, 2], [3]; [4, 5], [6, 7, 8]};
            C = reshape(C, [2, 2, 1]);

            M = NDcell2mat(C);

            testCase.verifyEqual(size(M), [2, 2, 3]);
            testCase.verifyEqual(squeeze(M(1, 1, 1:2)), [1; 2], 'AbsTol', 1e-14);
            testCase.verifyTrue(isnan(M(1, 1, 3)));
        end

        function test_default_filler_is_NaN_when_V_omitted(testCase)
            C = {[1;2]; [3]};
            M = NDcell2mat(C);

            testCase.verifyTrue(isnan(M(2, 2)), 'Expected NaN filler at empty position');
            testCase.verifyEqual(M(1, 1), 1);
            testCase.verifyEqual(M(2, 1), 3);
        end

        function test_custom_numeric_filler_minus_99(testCase)
            C = {[1;2]; [3]};
            M = NDcell2mat(C, -99);

            testCase.verifyEqual(M(1, 1), 1);
            testCase.verifyEqual(M(2, 1), 3);
            testCase.verifyEqual(M(2, 2), -99, 'Expected custom filler -99');
        end

        function test_scalar_only_cell_equals_cell2mat(testCase)
            C = {5; 10; 15};
            M = NDcell2mat(C);
            expected = cell2mat(C);

            testCase.verifyEqual(M, expected);
            testCase.verifyEqual(size(M), [3, 1]);
        end

        function test_cell_containing_empty_numeric(testCase)
            C = {[1;2]; []; [3;4;5]};
            M = NDcell2mat(C);

            testCase.verifyEqual(M(1, 1:2)', [1; 2]);
            testCase.verifyTrue(all(isnan(M(2, 1:3))), 'Expected all NaN in empty cell row');
            testCase.verifyEqual(M(3, 1:3)', [3; 4; 5]);
            testCase.verifyEqual(size(M), [3, 3]);
        end

        function test_non_numeric_content_error(testCase)
            % NDcell2mat.m's input-validation assert() carries no error
            % identifier; verify by function handle only.
            C = {'hello'};
            testCase.verifyError(@() NDcell2mat(C), '');

            C = {[1, 2], 'x'};
            testCase.verifyError(@() NDcell2mat(C), '');
        end

        function test_char_filler_NaN_converts_and_warns(testCase)
            % The filler-coercion warning() call carries no identifier.
            C = {[1;2]; [3]};

            testCase.verifyWarning(@() NDcell2mat(C, 'NaN'), '');

            M = NDcell2mat(C, 'NaN');
            M_expected = NDcell2mat(C);

            testCase.verifyEqual(M, M_expected, 'AbsTol', 1e-14);
        end

        function test_empty_cell_array_error(testCase)
            % Known limitation (README/docstring): C={} currently errors.
            % Not a fix. The error originates from a built-in size-vector
            % assignment (S(X)=N with N=[]), not from NDcell2mat.m's own
            % assert(), so its identifier is interpreter- and version-
            % dependent (observed: MATLAB:matrix:singleSubscriptNumelMismatch
            % under MATLAB; Octave:nonconformant-args under Octave). Verify
            % only that an error is raised, not its identifier.
            C = {};
            threw = false;
            try
                NDcell2mat(C);
            catch
                threw = true;
            end
            testCase.verifyTrue(threw, 'Expected NDcell2mat({}) to error (known limitation).');
        end

        function test_logical_content_unsupported_error(testCase)
            % Documented limitation: logical content is rejected by the same
            % non-identifier-carrying assert() as non-numeric content.
            C = {[true, false]; [true]};
            testCase.verifyError(@() NDcell2mat(C), '');
        end

    end
end
