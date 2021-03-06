\name{fittestArimaKF}
\alias{fittestArimaKF}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Automatic ARIMA fitting and prediction with Kalman filter 
%%  ~~function to do ... ~~
}
\description{
The function predicts and returns the next n consecutive values of a univariate time series using the best evaluated ARIMA model automatically fitted with Kalman filter. It also evaluates the fitness of the produced model, using AICc, AIC, BIC and logLik criteria, and its prediction accuracy, using the MSE, NMSE, MAPE, sMAPE and maximal error accuracy measures.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
fittestArimaKF(timeseries, timeseries.test, na.action = na.omit,
se.fit = FALSE, filtered = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{timeseries}{A vector or univariate time series which contains the values used for fitting an ARIMA model with Kalman filter.
%%     ~~Describe \code{timeseries} here~~
}
  \item{timeseries.test}{A vector or univariate time series containing a continuation for \code{timeseries} with actual values. The number of consecutive values to be predicted is assumed to be equal to the length of \code{timeseries.test}. It is used as a testing set and base for calculation of prediction error measures.
%%     ~~Describe \code{timeseries.cont} here~~
}
  \item{na.action}{A function for treating missing values in \code{timeseries} and \code{timeseries.test}. The default function is \code{\link{na.omit}}, which omits any missing values found in \code{timeseries} or \code{timeseries.test}.
%%     ~~Describe \code{na.action} here~~
}
  \item{se.fit}{If \code{se.fit} is \code{TRUE}, the standard errors of the predictions are returned.
%%     ~~Describe \code{se.fit} here~~
}
  \item{filtered}{If \code{filtered} is \code{TRUE}, Kalman filtered time series observations are used for prediction, otherwise, Kalman smoothed observations are used for prediction.
%%     ~~Describe \code{filtered} here~~
}
}
\details{A best ARIMA model is automatically fitted by the \code{\link{auto.arima}} function in the \code{forecast} package. The coefficients of this model are then used as initial parameters for optimization of a state space model (\code{\link{SSModel}}) using the Kalman filter and functions of the \code{KFAS} package (see \code{\link{SSMarima}} and \code{\link{artransform}}). A set of different ARIMA state space models is generated by different initial parameterization during the model optimization process.

The generated models are used for time series prediction. Fitness measures (AICc, AIC, BIC, log-likelihood) and prediction accuracy measures (MSE, NMSE, MAPE, sMAPE, maximal error) are calculated for each model.

The models are ranked and the best evaluated fitted ARIMA model is selected based on the lowest value of the TSPredC criterion.

The TSPredC criterion is calculated as the sum of the rank possitions of a model (1 = 1st position = better ranked model, 2 = 2nd position, etc.) on each calculated fitness or prediction accuracy measure.
%%  ~~ If necessary, more details than the description above ~~
}
\value{A list with components:
\item{model}{A list of class "SSModel" containing the best evaluated ARIMA model fitted with Kalman Filter.}
\item{AICc}{Numeric value of the computed AICc criterion of the best evaluated model.}
\item{AIC}{Numeric value of the computed AIC criterion of the best evaluated model.}
\item{BIC}{Numeric value of the computed BIC criterion of the best evaluated model.}
\item{logLik}{Numeric value of the computed log-likelihood of the best evaluated model.}
\item{pred}{A time series of predictions of the best evaluated model. If \code{se.fit} is \code{TRUE}, the estimated standard errors are included. See \code{\link{predict.SSModel}}.}
\item{MSE}{Numeric value of the resulting MSE error of prediction.}
\item{NMSE}{Numeric value of the resulting NMSE error of prediction.}
\item{MAPE}{Numeric value of the resulting MAPE error of prediction.}
\item{sMAPE}{Numeric value of the resulting sMAPE error of prediction.}
\item{MaxError}{Numeric value of the maximal error of prediction.}
\item{rank}{Data.frame with the fitness and prediction accuracy criteria computed for all ARIMA with Kalman filter models considered ranked by the TSPredC value. It has the attribute \code{"ranked.models"}, which is a list of objects of class "SSModel" containing all the evaluated ARIMA models fitted with Kalman Filter, also ranked by the TSPredC value.}
}
\references{
R.J. Hyndman and G. Athanasopoulos, 2013, Forecasting: principles and practice. OTexts.

R.H. Shumway and D.S. Stoffer, 2010, Time Series Analysis and Its Applications: With R Examples. 3rd ed. 2011 edition ed. New York, Springer.
%% ~put references to the literature/web site here ~
}
\author{
Rebecca Pontes Salles
%%  ~~who you are~~
}
\seealso{\code{\link{fittestArima}}, \code{\link{fittestLM}}, \code{\link{marimapred}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
\dontrun{
data(CATS,CATS.cont)
fArimaKF <- fittestArimaKF(CATS[,2],CATS.cont[,2], se.fit=TRUE, filtered=TRUE)
#predicted values and estimated standard errors
pred <- fArimaKF$pred
#model information
fArimaKF$rank[1,]

#extracting Kalman filtered and smoothed time series from the best fitted model
fs <- KFAS::KFS(fArimaKF$model,filtering=c("state","mean"),smoothing=c("state","mean"))
f <- fitted(fs, filtered = TRUE) #Kalman filtered time  series
s <- fitted(fs) #Kalman smoothed time  series
#plotting the time series data
plot(c(CATS[,2],CATS.cont[,2]),type='o',lwd=2,xlim=c(960,1000),ylim=c(200,600),
 xlab="Time",ylab="ARIMAKF")
#plotting the Kalman filtered time series
lines(f,col='red',lty=2,lwd=2)
#plotting the Kalman smoothed time series
lines(s,col='green',lty=2,lwd=2)
#plotting predicted values
lines(ts(pred[,1],start=981),lwd=2,col='blue')
#plotting estimated standard errors (confidence interval)
lines(ts(pred[,1]+pred[,4],start=981),lwd=2,col='light blue')
lines(ts(pred[,1]-pred[,4],start=981),lwd=2,col='light blue')
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ARIMA }% __ONLY ONE__ keyword per line
\keyword{ automatic }
\keyword{ fitting }
\keyword{ Kalman }
\keyword{ filter }
\keyword{ adjustment }
\keyword{ prediction }
\keyword{ evaluation }
\keyword{ criterion }
\keyword{ errors }