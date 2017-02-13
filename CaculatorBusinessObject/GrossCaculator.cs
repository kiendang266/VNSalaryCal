using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CaculatorBusinessObject
{
    public class GrossCaculator
    {
        public static decimal CapMonthForSocialInsurance = 20;
        public static decimal CapMonthForHealthInsurance = 20;
        public static decimal CapMonthForUnemployedInsurance = 20;

        public static decimal TotalPit(decimal taxedSalary)
        {
            decimal totalTaxed = 0;
            if (taxedSalary <= 5000000)
                totalTaxed = taxedSalary * (decimal)0.05;
            else if (taxedSalary > 5000000 && taxedSalary <= 10000000)
                totalTaxed = ((taxedSalary - 5000000) * (decimal)0.1) + 250000;
            else if (taxedSalary > 10000000 && taxedSalary <= 18000000)
                totalTaxed = ((taxedSalary - 10000000) * (decimal)0.15) + 750000;
            else if (taxedSalary > 18000000 && taxedSalary <= 32000000)
                totalTaxed = ((taxedSalary - 18000000) * (decimal)0.2) + 1950000;
            else if (taxedSalary > 32000000 && taxedSalary <= 52000000)
                totalTaxed = ((taxedSalary - 32000000) * (decimal)0.25) + 4750000;
            else if (taxedSalary > 52000000 && taxedSalary <= 80000000)
                totalTaxed = ((taxedSalary - 52000000) * (decimal)0.3) + 9750000;
            else
                totalTaxed = ((taxedSalary - 80000000)*(decimal) 0.35) + 18150000;

            return totalTaxed;
        }

        public static decimal NetToBeforeTaxed(decimal netSalary, decimal reduction)
        {
            if(netSalary <= reduction)
            {
                return netSalary;
            }

            if((netSalary - reduction)/(decimal) 0.95 <= 5000000)
            {
                return (netSalary - ((decimal) 0.05*reduction))/(decimal) 0.95;
            }
            if((netSalary - reduction - 250000)/(decimal) 0.9 <= 10000000)
            {
                return (netSalary - ((decimal) 0.1*reduction) - 250000)/(decimal) 0.9;
            }
            if((netSalary-reduction-750000)/(decimal)0.85<=18000000)
            {
                return (netSalary - ((decimal) 0.15*reduction) - 750000)/(decimal) 0.85;
            }
            if((netSalary-reduction-1650000)/(decimal)0.8<=32000000)
            {
                return (netSalary - ((decimal) 0.2*reduction) - 1650000)/(decimal) 0.8;
            }
            if((netSalary-reduction-3250000)/(decimal)0.75<=52000000)
            {
                return (netSalary - ((decimal) 0.25*reduction) - 3250000)/(decimal) 0.75;
            }
            if ((netSalary - reduction - 5850000) / (decimal)0.7 <= 80000000)
            {
                return (netSalary - ((decimal) 0.3*reduction) - 5850000)/(decimal) 0.7;
            }
            if ((netSalary - reduction - 9850000) / (decimal)0.65 > 80000000)
            {
                return (netSalary - ((decimal) 0.35*reduction) - 9850000)/(decimal) 0.65;
            }

            return 0;
        }
    }
}
