# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("rpanel")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Main computation
x        = seq(-6, 6, 0.1)
ylims    = c(0, 0.4)
limits.p = c(-20, 20)
panel    = rp.control()
rp.slider(panel, mean1, -4, 4, action = plot.conf.int, showvalue = T, initval = 0)
rp.slider(panel, sd1, 0.5, 3, action = plot.conf.int, showvalue = T, initval = 1)
rp.slider(panel, mean2, -4, 4, action = plot.conf.int, showvalue = T, initval = 1)
rp.slider(panel, sd2, 0.5, 3, action = plot.conf.int, showvalue = T, initval = 1)
rp.slider(panel, alpha, 0.5, 0.99, action = plot.conf.int, showvalue = T, initval = 0.99)
rp.checkbox(panel, compare, action = plot.conf.int)
rp.checkbox(panel, VaR, action = plot.conf.int)
rp.checkbox(panel, CVaR, action = plot.conf.int)
rp.button(panel, action = pdf.plot, title = "Save Plot")

panel$mean1   = 0
panel$mean2   = 1
panel$sd1     = 1
panel$sd2     = 1
panel$alpha   = 0.01
panel$compare = FALSE
panel$VaR     = FALSE

plot.conf.int = function(panel) {
    par(mai = c(0.4, 0.1, 0.4, 0.1))
    q1 = qnorm(panel$alpha, panel$mean1, panel$sd1)
    q2 = qnorm(panel$alpha, panel$mean2, panel$sd2)
    h  = 0.02
    if (!panel$compare) {
        if (panel$VaR) {
            plot(limits.p, c(0, 0), col = "black", xlim = c(-4, 4), ylim = c(0, 0.4), 
                lwd = 1, lty = "solid", main = paste("VaR(X) = ", round(q1, 3), sep = ""), 
                axes = F, frame = T, xlab = "", ylab = "")
        } else {
            plot(limits.p, c(0, 0), col = "black", xlim = c(-4, 4), ylim = c(0, 0.4), 
                lwd = 1, lty = "solid", main = paste("mu(X) = ", round(panel$mean1, 
                  3), sep = ""), axes = F, frame = T, xlab = "", ylab = "")
        }
    } else {
        if (panel$VaR) {
            plot(limits.p, c(0, 0), col = "black", xlim = c(-4, 4), ylim = c(0, 0.4), 
                lwd = 1, lty = "solid", main = paste("VaR(X) = ", round(q1, 3), ", VaR(Y) = ", 
                  round(q2, 3), sep = ""), axes = F, frame = T, xlab = "", ylab = "")
        } else {
            plot(limits.p, c(0, 0), col = "black", xlim = c(-4, 4), ylim = c(0, 0.4), 
                lwd = 1, lty = "solid", main = paste("mu(X) = ", round(panel$mean1, 
                  3), ", mu(Y) = ", round(panel$mean2, 3), sep = ""), axes = F, frame = T, 
                xlab = "", ylab = "")
        }
    }
    if (panel$VaR) 
        polygon(rbind(c(q1, 0), cbind(seq(q1, max(x) + 2, 0.1), dnorm(seq(q1, max(x) + 
            2, 0.1), panel$mean1, panel$sd1))), angle = 45, col = rgb(1, 0.2, 0.2, 
            0.4), lty = 1)  # 'light pink'
    if (panel$compare) 
        if (panel$VaR) 
            polygon(rbind(c(q2, 0), cbind(seq(q2, max(x) + 2, 0.1), dnorm(seq(q2, 
                max(x) + 2, 0.1), panel$mean2, panel$sd2))), angle = 45, col = rgb(0.2, 
                0.2, 1, 0.4), lty = 1)  # 'light blue'
    beta_x = (x[which(min(abs(dnorm(x[x < panel$mean2], panel$mean2, panel$sd2) - 
        h))[1] == abs(dnorm(x[x < panel$mean2], panel$mean2, panel$sd2) - h))] + 
        q2)/2
    alpha_x = (x[which(x == (x[x < panel$mean1])[1]) + which(min(abs(dnorm(x[x < 
        panel$mean1], panel$mean1, panel$sd1) - h))[1] == abs(dnorm(x[x < panel$mean1], 
        panel$mean1, panel$sd1) - h))] + q1)/2
    
    # if(panel$compare)if(panel$VaR)text(beta_x, dnorm(beta_x, panel$mean2, panel$sd2) / 2, expression(1-alpha)) if(panel$VaR)text(alpha_x, dnorm(alpha_x, panel$mean1, panel$sd1) / 2, expression(1-alpha))
    lines(limits.p, c(0, 0), col = "black", )
    lines(x, dnorm(x, panel$mean1, panel$sd1), type = "l", col = "red3", lwd = 2)
    if (panel$compare) 
        lines(x, dnorm(x, panel$mean2, panel$sd2), col = "blue3", lwd = 2)
    if (!panel$compare) {
        if (panel$VaR) {
            axis(1, c(panel$mean1, q1), c(expression(mu[X]), expression(VaR[alpha](X))))
        } else {
            axis(1, panel$mean1, expression(mu[X]))
        }
    } else {
        if (panel$VaR) {
            axis(1, c(panel$mean1, panel$mean2, q1, q2), c(expression(mu[X]), expression(mu[Y]), 
                expression(VaR[alpha](X)), expression(VaR[alpha](Y))))
        } else {
            axis(1, c(panel$mean1, panel$mean2), c(expression(mu[X]), expression(mu[Y])))
        }
    }
    lines(c(panel$mean1, panel$mean1), c(-1, dnorm(panel$mean1, panel$mean1, panel$sd1)), 
        lty = "dotted")
    if (panel$compare) 
        lines(c(panel$mean2, panel$mean2), c(-1, dnorm(panel$mean2, panel$mean2, 
            panel$sd2)), lty = "dotted")
    if (panel$VaR) 
        lines(c(q1, q1), c(-1, dnorm(q1, panel$mean1, panel$sd1)), lwd = 1, col = "red3")
    if (panel$compare) 
        if (panel$VaR) 
            lines(c(q2, q2), c(-1, dnorm(q2, panel$mean2, panel$sd2)), lwd = 1, col = "blue3")
    CVaRX = panel$sd1 * dnorm(qnorm(panel$alpha))/(1 - panel$alpha) + panel$mean1
    CVaRY = panel$sd2 * dnorm(qnorm(panel$alpha))/(1 - panel$alpha) + panel$mean2
    max.CVaR = max(dnorm(x, panel$mean1, panel$sd1), dnorm(x, panel$mean2, panel$sd2))
    if (panel$CVaR) {
        text(CVaRX, max(ylims) * 0.9, expression(CVaR[alpha](X)), col = "red3")
        lines(c(CVaRX, CVaRX), c(-1, max(ylims) * 0.87), lwd = 1, col = "red3")
    }
    if (panel$compare) 
        if (panel$CVaR) {
            text(CVaRY, max(ylims), expression(CVaR[alpha](Y)), col = "blue3")
            lines(c(CVaRY, CVaRY), c(-1, max(ylims) * 0.97), lwd = 1, col = "blue3")
        }
    panel
}
pdf.plot = function(panel) {
    pdf(paste("mu1_", (1000 * round(panel$mean1, 3)), "sd1_", (1000 * round(panel$sd1, 
        3)), "mu2_", (1000 * round(panel$mean2, 3)), "sd2_", (1000 * round(panel$sd2, 
        3)), if (panel$VaR) 
        "_VaR", if (panel$CVaR) 
        "_CVaR", if (panel$compare) 
        "_two", ".pdf", sep = ""), width = 6, height = 4)
    plot.conf.int(panel)
    dev.off()
}

# mu1 = -4
# sd1 = 2.46
# mu2 = -0.6
# sd2 = 1.0
