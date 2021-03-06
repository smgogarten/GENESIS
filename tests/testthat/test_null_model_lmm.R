context("check null model lmm")

test_that("lmm - with group", {
    dat <- .testNullInputs()

    nullmod <- .fitNullModel(dat$y, dat$X, dat$cor.mat, group.idx=dat$group.idx, verbose=FALSE)

    # Check for expected names.
    expected_names <- c("model", "varComp", "varCompCov", "fixef",
                        "betaCov", "fit", "logLik", "logLikR", "AIC", "model.matrix",
                        "group.idx", "W", "cholSigmaInv", "converged", "zeroFLAG",
                        "niter", "RSS", "CX", "CXCXI", "RSS0")
    expect_true(setequal(names(nullmod), expected_names))

    # Check names of fit data frame.
    expected_names <- c("outcome", "workingY", "fitted.values", "resid.marginal",
                        "resid.conditional", "resid.PY", "resid.cholesky",
                        "linear.predictor")
    expect_true(setequal(names(nullmod$fit), expected_names))

    # Check names of model element.
    expected_names <- c("hetResid", "family")
    expect_true(setequal(names(nullmod$model), expected_names))
    expect_true(nullmod$model$hetResid)
    expect_equal(nullmod$model$family$family, "gaussian")
    expect_true(nullmod$model$family$mixedmodel)

    expect_true(nullmod$converged)
    expect_equivalent(nullmod$fit$workingY, dat$y)
    expect_equivalent(nullmod$fit$outcome, dat$y)
    expect_equivalent(nullmod$model.matrix, dat$X)
    expect_equivalent(nullmod$fit$linear.predictor, nullmod$fit$workingY - nullmod$fit$resid.conditional)
    expect_true(is(nullmod, "GENESIS.nullMixedModel"))

})


test_that("lmm - without group", {
    dat <- .testNullInputs()
    nullmod <- .fitNullModel(dat$y, dat$X, dat$cor.mat, verbose=FALSE)

    expect_false(nullmod$model$hetResid)
    expect_true(nullmod$converged)
    expect_equivalent(nullmod$fit$workingY, dat$y)
    expect_equivalent(nullmod$fit$outcome, dat$y)
    expect_equivalent(nullmod$model.matrix, dat$X)
    expect_true(is(nullmod, "GENESIS.nullMixedModel"))

})
