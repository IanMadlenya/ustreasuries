% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_rates.R
\name{CoerceFedInvest_xts}
\alias{CoerceFedInvest_xts}
\title{Coerce a slice of FedInvest data to xts}
\usage{
CoerceFedInvest_xts(bond_data)
}
\arguments{
\item{bond_data}{a slice of the FedInvest data}
}
\value{
a list
\itemize{
     \item \bold{$rate_table_xts} the xts frame
     \item \bold{$unique_maturities} a numeric vector of the maturities
     for which there is a column in the xts frame in fractional-year format
     (1-month = 1/12 = 0.08333333). It should be noted that if bonds in a
     matruity range of say 15.5-16.5 are not found in the data, there will
     not be a 16.00000 maturity column in the xts frame.
     \item \bold{$modified_data} the original data with additional columns
         \itemize{
             \item \bold{fracyrs} fractional-year time to maturity
             \item \bold{maturities} the regularized fractional-year time to maturity
             \item \bold{coupon} numeric coupon from percent-format RATE
             \item \bold{mid} the mid-point between BUY & SELL
             \item \bold{YTM} yield to maturity
         }
}
}
\description{
The FedInvest data contains one row per bond on a particular date.
This function converts that format into an xts frame.
}
\details{
The FedInvest data has one row per date, per bond. For analyses such as
Nelson Seigel and Svensson we need the data in an xts frame with the format
of one row per date and one column per maturity.

This function performs this primary transformation: The bond data has a
continuous set of maturities; a fixed xts table needs discrete maturities.
So, for example, the 1-year maturity data comprises the average YTM for all
the bonds with maturities between 0.5 and 1.5 years.

A number of minor transformations are also performed such as converting
the RATE data from a character percent format (7.82\%) to decimal (0.0782)
}
\examples{
library(ustreasuries)
library(magrittr)

start.date <- Sys.Date() - 25
end.date   <- Sys.Date()

rate_table_list <- dplyr::filter(FedInvestData(),
                                  Date >= start.date &
                                  Date <= end.date   &
                                  SECURITY.TYPE != "TIPS") \%>\%
    CoerceFedInvest_xts()

rate_table_xts    <- rate_table_list$rate_table_xts
unique_maturities <- rate_table_list$unique_maturities
modified_data     <- rate_table_list$modified_data

unique_maturities

knitr::kable(as.data.frame(modified_data[30:32, c(2:4,10:14)]),
caption="Sample of FedInvest Data with additional Data",
row.names=FALSE)

knitr::kable(as.data.frame(rate_table_xts[1:3, 1:5]),
caption="Sample of FedInvest Data after Coersion to xts Format",
row.names=TRUE)

}
\author{
George Fisher
}
\seealso{
\code{\link{FedInvestData}} the function to download the FedInvest data
}

