ggs_rhat_temp <- 
function (D,g, family = NA, scaling = 1.5) 
{
  if (attributes(g)$nChains < 2) {
    stop("At least two chains are required")
  }
  if (!is.na(family)) {
    D <- get_family(D, family = family)
  }
  psi.dot <- D %>% group_by(Parameter, Chain) %>% summarize(psi.dot = mean(value))
  psi.j <- D %>% group_by(Parameter) %>% summarize(psi.j = mean(value))
  b.df <- inner_join(psi.dot, psi.j, by = "Parameter")
  B <- b.df %>% group_by(Parameter) %>% summarize(B = var(psi.j - 
                                                            psi.dot) * attributes(g)$nIterations)
  B <- unique(B)
  s2j <- D %>% group_by(Parameter, Chain) %>% summarize(s2j = var(value))
  W <- s2j %>% group_by(Parameter) %>% summarize(W = mean(s2j))
  BW <- inner_join(B, W, by = "Parameter") %>% mutate(wa = (((attributes(g)$nIterations - 
                                                                1)/attributes(g)$nIterations) * W) + ((1/attributes(g)$nIterations) * 
                                                                                                        B), Rhat = sqrt(wa/W))
  BW$Rhat[is.nan(BW$Rhat)] <- NA
  f <- ggplot(BW, aes(x = Rhat, y = Parameter)) + geom_point() + 
    xlab(expression(hat("R"))) + ggtitle("Potential Scale Reduction Factor")
  if (!is.na(scaling)) {
    scaling <- ifelse(scaling > max(BW$Rhat, na.rm = TRUE), 
                      scaling, max(BW$Rhat, na.rm = TRUE))
    f <- f + xlim(min(BW$Rhat, na.rm = TRUE), scaling)
  }
  return(f)
}