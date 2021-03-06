context("check null model linear regression")

test_that("linear regression", {
    n <- 100
    dat <- .testNullInputs(n)

    nullmod <- .fitNullModel(dat$y, dat$X, verbose=FALSE)

    # Check for expected names.
    expected_names <- c("model", "varComp", "varCompCov", "fixef",
                        "betaCov", "fit", "logLik",
                        "AIC", "model.matrix",
                        "group.idx", "cholSigmaInv", "converged", "zeroFLAG",
                        "RSS", "CX", "CXCXI", "RSS0")
    expect_true(setequal(names(nullmod), expected_names))

    # Check names of fit data frame.
    expected_names <- c("outcome", "workingY", "fitted.values", "resid.marginal",
                        "resid.PY", "resid.cholesky")
    expect_true(setequal(names(nullmod$fit), expected_names))

    # Check names of model element.
    expected_names <- c("hetResid", "family")
    expect_true(setequal(names(nullmod$model), expected_names))
    expect_false(nullmod$model$hetResid)
    expect_equal(nullmod$model$family$family, "gaussian")
    expect_false(nullmod$model$family$mixedmodel)

    lm.mod <- lm(dat$y ~ -1 + dat$X)

    expect_equal(nullmod$fit$fitted.values, unname(fitted(lm.mod)))
    expect_equivalent(nullmod$fit$resid.marginal, lm.mod$resid)
    expect_true(all(nullmod$fixef == summary(lm.mod)$coef))
    expect_equal(nullmod$varComp, summary(lm.mod)$sigma^2)
    expect_null(nullmod$varCompCov)
    expect_equivalent(nullmod$betaCov, vcov(lm.mod))
    expect_equivalent(nullmod$fit$fitted.values, fitted(lm.mod))
    expect_equal(nullmod$logLik, as.numeric(logLik(lm.mod)))
    expect_equal(nullmod$AIC, AIC(lm.mod))
    expect_equivalent(nullmod$fit$workingY, dat$y)
    expect_equivalent(nullmod$fit$outcome, dat$y)
    expect_equivalent(nullmod$model.matrix, dat$X)
    expect_equal(nullmod$cholSigmaInv, 1/summary(lm.mod)$sigma)
    expect_true(nullmod$converged)
    expect_null(nullmod$zeroFLAG)
    expect_equal(nullmod$RSS, sum(lm.mod$resid^2)/(summary(lm.mod)$sigma^2*(n - ncol(dat$X))))
    expect_true(is(nullmod, "GENESIS.nullModel"))
})
