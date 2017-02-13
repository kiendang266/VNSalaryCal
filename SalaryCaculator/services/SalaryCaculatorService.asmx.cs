using System;
using System.ComponentModel;
using System.Globalization;
using System.Web.Services;
using CaculatorBusinessObject;

namespace SalaryCaculator.services
{
    /// <summary>
    /// Summary description for SalaryCaculatorService
    /// </summary>
    [WebService(Namespace = "http://kiendang.com/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class SalaryCaculatorService : WebService
    {
        const string Specifier = "#,###.##";
        [WebMethod]
        public string GrossToNet(string income, string personalReduction, string dependant, string numberOfDependant,
            bool isFullWage, string otherWage, string minimumAreaSalary, string basedSalary, string socialInsurance,
            string healthInsurance, string unemployedInsurance)
        {
            var grossSalary = decimal.Parse(income);
            var amountPersonalReduction = decimal.Parse(personalReduction);

            var insuranceBased = isFullWage ? grossSalary : decimal.Parse(otherWage);

            // bảo hiểm xã hội cap 20 tháng lương cơ bản
            var amountSocialInsurance = insuranceBased >
                                            GrossCaculator.CapMonthForSocialInsurance*decimal.Parse(basedSalary)
                                                ? (GrossCaculator.CapMonthForSocialInsurance*decimal.Parse(basedSalary))*
                                                  decimal.Parse(socialInsurance)/100
                                                : insuranceBased*decimal.Parse(socialInsurance)/100;
            // bảo hiểm y tế cap 20 tháng lương cơ bản
            var amountHealthInsurance = insuranceBased >
                                            GrossCaculator.CapMonthForHealthInsurance*decimal.Parse(basedSalary)
                                                ? (GrossCaculator.CapMonthForHealthInsurance*decimal.Parse(basedSalary))*
                                                  decimal.Parse(healthInsurance)/100
                                                : insuranceBased*decimal.Parse(healthInsurance)/100;
            // bảo hiểm thất nghiệp cap 20 tháng lương tối thiểu vùng
            var amountUnemployedInsurance = insuranceBased >
                                                (GrossCaculator.CapMonthForUnemployedInsurance*decimal.Parse(minimumAreaSalary))
                                                    ? (GrossCaculator.CapMonthForUnemployedInsurance*
                                                       decimal.Parse(minimumAreaSalary))*decimal.Parse(unemployedInsurance)/100
                                                    : insuranceBased*decimal.Parse(unemployedInsurance)/100;

            var beforTaxed = grossSalary - (amountSocialInsurance + amountHealthInsurance + amountUnemployedInsurance);
            var dependantReduction = decimal.Parse(dependant)*decimal.Parse(numberOfDependant);
            
            decimal taxedSalary;
            if (beforTaxed <= amountPersonalReduction)
                taxedSalary = (decimal)0.0;
            else
                taxedSalary = beforTaxed - (amountPersonalReduction + dependantReduction);

            //taxedSalary = beforTaxed - (amountPersonalReduction + dependantReduction);
            var pit = GrossCaculator.TotalPit(taxedSalary);
            var netSalary = beforTaxed - pit;

            return "{" +
                   string.Format("\"gross\":\"{0}\", \"social\":\"{1}\", \"health\":\"{2}\", \"unemployed\":\"{3}\"," +
                                 "\"beforetaxed\":\"{4}\", \"personal\":\"{5}\", \"dependant\":\"{6}\", \"taxedsalary\":\"{7}\"," +
                                 "\"pit\":\"{8}\", \"net\":\"{9}\", \"progressive\":{10}, \"employer\":{11}",
                                 grossSalary.ToString(Specifier), amountSocialInsurance.ToString(Specifier),
                                 amountHealthInsurance.ToString(Specifier),
                                 amountUnemployedInsurance.ToString(Specifier),
                                 beforTaxed.ToString(Specifier),
                                 decimal.Parse(personalReduction).ToString(Specifier),
                                 dependantReduction.ToString(Specifier),
                                 taxedSalary.ToString(Specifier), pit.ToString(Specifier),
                                 netSalary.ToString(Specifier),
                                 ProgressiveCaculator(taxedSalary.ToString(Specifier)),
                                 EmployerPay(income, isFullWage, otherWage, minimumAreaSalary, basedSalary,
                                             socialInsurance, healthInsurance, unemployedInsurance)) + "}";
        }

        [WebMethod]
        public string NetToGross(string incomeNet, string personalReduction, string dependant, string numberOfDependant,
            bool isFullWage, string otherWage, string minimumAreaSalary, string basedSalary, string socialInsurance,
            string healthInsurance, string unemployedInsurance)
        {
            var netSalary = decimal.Parse(incomeNet);
            var dependantReduction = decimal.Parse(dependant) * decimal.Parse(numberOfDependant);

            var beforeTaxed = GrossCaculator.NetToBeforeTaxed(netSalary,
                                                             decimal.Parse(personalReduction) + dependantReduction);

            if (beforeTaxed == 0)
                throw new Exception("Input string was not in a correct format when running this method.");

            decimal grossSalary = 0;

            if(!isFullWage)
            {
                decimal insuranceBased; 
                decimal.TryParse(otherWage, out insuranceBased);

                var amountSocialInsurance = insuranceBased >
                                            GrossCaculator.CapMonthForSocialInsurance * decimal.Parse(basedSalary)
                                                ? (GrossCaculator.CapMonthForSocialInsurance * decimal.Parse(basedSalary)) *
                                                  decimal.Parse(socialInsurance) / 100
                                                : insuranceBased * decimal.Parse(socialInsurance) / 100;
                var amountHealthInsurance = insuranceBased >
                                            GrossCaculator.CapMonthForHealthInsurance * decimal.Parse(basedSalary)
                                                ? (GrossCaculator.CapMonthForHealthInsurance * decimal.Parse(basedSalary)) *
                                                  decimal.Parse(healthInsurance) / 100
                                                : insuranceBased * decimal.Parse(healthInsurance) / 100;
                var amountUnemployedInsurance = insuranceBased >
                                                    (GrossCaculator.CapMonthForUnemployedInsurance * decimal.Parse(minimumAreaSalary))
                                                        ? (GrossCaculator.CapMonthForUnemployedInsurance *
                                                           decimal.Parse(minimumAreaSalary)) * decimal.Parse(unemployedInsurance) / 100
                                                        : insuranceBased * decimal.Parse(unemployedInsurance) / 100;
                grossSalary = beforeTaxed + amountSocialInsurance + amountHealthInsurance + amountUnemployedInsurance;
            }
            else
            {
                var totalPercentageInsurance = decimal.Parse(socialInsurance) + decimal.Parse(healthInsurance) +
                                               decimal.Parse(unemployedInsurance);
                var minimumBeforeTaxed = (decimal.Parse(basedSalary)*GrossCaculator.CapMonthForSocialInsurance) -
                                         ((decimal.Parse(basedSalary)*GrossCaculator.CapMonthForSocialInsurance)*
                                          totalPercentageInsurance/100);

                if(beforeTaxed <= minimumBeforeTaxed)
                {
                    grossSalary = (beforeTaxed*100)/(100 - totalPercentageInsurance);
                }
                else
                {
                    var amountSocialInsurance = (decimal.Parse(basedSalary)*GrossCaculator.CapMonthForSocialInsurance)*
                                                decimal.Parse(socialInsurance)/100;
                    var amountHealthInsurance = (decimal.Parse(basedSalary)*GrossCaculator.CapMonthForHealthInsurance)*
                                                decimal.Parse(healthInsurance)/100;

                    //edit date: 29 Sep 2016
                    // Mức bảo hiểm thất nghiệp không vượt quá 70 triệu
                    // lấy 70 triệu chuyển từ gross qua net -> thu nhập trước thuế không được quá 67001000
                    //edit date: 30/1/2017
                    // tăng lương tối thiểu vùng -> mức đóng bảo hiểm tăng thành 75 triệu
                    if (beforeTaxed > 71951000)//67001000)
                    {
                        grossSalary = beforeTaxed + amountSocialInsurance + amountHealthInsurance + 750000;
                    }
                    else
                    {

                        var grossExceptUnemployedInsurance = beforeTaxed + amountSocialInsurance + amountHealthInsurance;

                        grossSalary = grossExceptUnemployedInsurance * 100 / (100 - decimal.Parse(unemployedInsurance));
                    }
                }
            }

            return GrossToNet(grossSalary.ToString(CultureInfo.InvariantCulture), personalReduction, dependant, numberOfDependant, isFullWage,
                              otherWage, minimumAreaSalary, basedSalary, socialInsurance, healthInsurance,
                              unemployedInsurance);
        }

        [WebMethod]
        public string ProgressiveCaculator(string taxedSalary)
        {
            decimal decimalTaxed;
            decimal.TryParse(taxedSalary, out decimalTaxed);
            if (decimalTaxed <= 5000000)
            {
                return "{" + string.Format("\"r1\":\"{0}\"",
                                           (decimalTaxed*(decimal) 0.05).ToString(Specifier)) + "}";
            }
            if (decimalTaxed > 5000000 && decimalTaxed <= 10000000)
            {
                return "{" + string.Format("\"r1\":\"{0}\", \"r2\":\"{1}\"",
                                           ((decimal) 250000).ToString(Specifier),
                                           ((decimalTaxed-5000000)*(decimal) 0.1).ToString(Specifier)) + "}";
            }
            if (decimalTaxed > 10000000 && decimalTaxed <= 18000000)
            {
                return "{" + string.Format("\"r1\":\"{0}\", \"r2\":\"{1}\", \"r3\":\"{2}\"",
                                           ((decimal)250000).ToString(Specifier),
                                           ((decimal)500000).ToString(Specifier),
                                           ((decimalTaxed - 10000000) * (decimal)0.15).ToString(Specifier)) + "}";
            }
            if (decimalTaxed > 18000000 && decimalTaxed <= 32000000)
            {
                return "{" + string.Format("\"r1\":\"{0}\", \"r2\":\"{1}\", \"r3\":\"{2}\"," +
                                           "\"r4\":\"{3}\"",
                                           ((decimal)250000).ToString(Specifier),
                                           ((decimal)500000).ToString(Specifier),
                                           ((decimal)1200000).ToString(Specifier),
                                           ((decimalTaxed - 18000000) * (decimal)0.2).ToString(Specifier)) + "}";
            }
            if (decimalTaxed > 32000000 && decimalTaxed <= 52000000)
            {
                return "{" + string.Format("\"r1\":\"{0}\", \"r2\":\"{1}\", \"r3\":\"{2}\"," +
                                           "\"r4\":\"{3}\", \"r5\":\"{4}\"",
                                           ((decimal)250000).ToString(Specifier),
                                           ((decimal)500000).ToString(Specifier),
                                           ((decimal)1200000).ToString(Specifier),
                                           ((decimal)2800000).ToString(Specifier),
                                           ((decimalTaxed - 32000000) * (decimal)0.25).ToString(Specifier)) + "}";
            }
            if (decimalTaxed > 52000000 && decimalTaxed <= 80000000)
            {
                return "{" + string.Format("\"r1\":\"{0}\", \"r2\":\"{1}\", \"r3\":\"{2}\"," +
                                           "\"r4\":\"{3}\", \"r5\":\"{4}\", \"r6\":\"{5}\"",
                                           ((decimal)250000).ToString(Specifier),
                                           ((decimal)500000).ToString(Specifier),
                                           ((decimal)1200000).ToString(Specifier),
                                           ((decimal)2800000).ToString(Specifier),
                                           ((decimal)5000000).ToString(Specifier),
                                           ((decimalTaxed - 52000000) * (decimal)0.3).ToString(Specifier)) + "}";
            }
            return "{" + string.Format("\"r1\":\"{0}\", \"r2\":\"{1}\", \"r3\":\"{2}\"," +
                                       "\"r4\":\"{3}\", \"r5\":\"{4}\", \"r6\":\"{5}\"," +
                                       "\"r7\":\"{6}\"",
                                       ((decimal)250000).ToString(Specifier),
                                       ((decimal)500000).ToString(Specifier),
                                       ((decimal)1200000).ToString(Specifier),
                                       ((decimal)2800000).ToString(Specifier),
                                       ((decimal)5000000).ToString(Specifier),
                                       ((decimal)8400000).ToString(Specifier),
                                       ((decimalTaxed - 80000000) * (decimal)0.35).ToString(Specifier)) + "}";
        }

        [WebMethod]
        public string EmployerPay(string income, bool isFullWage, string otherWage,
            string minimumAreaSalary, string basedSalary, string socialInsurance,
            string healthInsurance, string unemployedInsurance)
        {
            var grossSalary = decimal.Parse(income);
            var insuranceBased = isFullWage ? grossSalary : decimal.Parse(otherWage);

            // bảo hiểm xã hội cap 20 tháng lương cơ bản
            var amountSocialInsurance = insuranceBased >
                                        GrossCaculator.CapMonthForSocialInsurance*decimal.Parse(basedSalary)
                                            ? (GrossCaculator.CapMonthForSocialInsurance*decimal.Parse(basedSalary))*
                                              (26 - decimal.Parse(socialInsurance))/100
                                            : insuranceBased*(26 - decimal.Parse(socialInsurance))/100;
            // bảo hiểm y tế cap 20 tháng lương cơ bản
            var amountHealthInsurance = insuranceBased >
                                        GrossCaculator.CapMonthForHealthInsurance*decimal.Parse(basedSalary)
                                            ? (GrossCaculator.CapMonthForHealthInsurance*decimal.Parse(basedSalary))*
                                              ((decimal) 4.5 - decimal.Parse(healthInsurance))/100
                                            : insuranceBased*((decimal) 4.5 - decimal.Parse(healthInsurance))/100;
            // bảo hiểm thất nghiệp cap 20 tháng lương tối thiểu vùng
            var amountUnemployedInsurance = insuranceBased >
                                            (GrossCaculator.CapMonthForUnemployedInsurance*
                                             decimal.Parse(minimumAreaSalary))
                                                ? (GrossCaculator.CapMonthForUnemployedInsurance*
                                                   decimal.Parse(minimumAreaSalary))*
                                                  (2 - decimal.Parse(unemployedInsurance))/100
                                                : insuranceBased*(2 - decimal.Parse(unemployedInsurance))/100;


            return "{" + string.Format("\"gross\":\"{0}\", \"social\":\"{1}\", \"health\":\"{2}\"," +
                                       "\"unemployed\":\"{3}\", \"total\":\"{4}\"",
                                       grossSalary.ToString(Specifier),
                                       amountSocialInsurance.ToString(Specifier),
                                       amountHealthInsurance.ToString(Specifier),
                                       amountUnemployedInsurance.ToString(Specifier),
                                       (grossSalary + amountSocialInsurance + amountHealthInsurance +
                                        amountUnemployedInsurance).ToString(Specifier)) + "}";
        }
    }
}
