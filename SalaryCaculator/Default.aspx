<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SalaryCaculator._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tính phí bảo hiểm, thuế thu nhập cá nhân, chuyển từ GROSS sang NET và ngược lại
        - Kien Dang</title>
    <meta name="description" content="Tính phí bảo hiểm, thuế thu nhập cá nhân, chuyển từ GROSS sang NET và ngược lại" />
    <meta name="keywords" content="tính phí, bảo hiểm, thuế, tncn, thu nhập cá nhân, gross, net" />
    <meta name="author" content="Kien Dang" />
    <link rel="stylesheet" type="text/css" href="/css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="/css/demo.css" />
    <link rel="stylesheet" type="text/css" href="/css/icons.css" />
    <link rel="stylesheet" type="text/css" href="/css/style5.css" />
    <link rel="stylesheet" type="text/css" href="/css/component.css" />
    <link rel="stylesheet" type="text/css" href="/fonts/font-awesome-4.2.0/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="/css/nlstyle.css" />
    <link rel="stylesheet" type="text/css" href="/css/table.css" />
    <link rel="stylesheet" type="text/css" href="/css/buttons.css" />

    <script src="/js/modernizr.custom.js" type="text/javascript"></script>

    <script src="/js/jquery-2.1.3.js" type="text/javascript"></script>

    <script src="/js/jquery.number.js" type="text/javascript"></script>

    <script src="/js/accounting.js" type="text/javascript"></script>

</head>
<body>
    <div class="container">
        <header class="codrops-header">
				<h1>Tính lương GROSS sang NET và ngược lại <span>Phát triển bởi <a href="http://kiendang.com">Kiên Đặng</a></span></h1>				
			</header>
        <div class="main">
            <div>
                Tỷ giá được cập nhật tự động từ ngân hàng thương mại cổ phần Ngoại thương Việt Nam
                (Vietcombank) lúc:
                <%=RateUpdatedTime%>
            </div>
            <section class="content bgcolor-8">
                    <span class="input input--isao">
                        <input class="input__field input__field--juro" type="text" id="txtVnd" />
                        <label class="input__label input__label--juro" for="txtVnd" data-content="Thu nhập VND">
                            <span class="input__label-content input__label-content--juro">Thu nhập VND</span>
                        </label>
                    </span>
                    <span class="input input--isao">
                        <input class="input__field input__field--juro" type="text" id="txtUsd" />
                        <label class="input__label input__label--juro" for="txtUsd" data-content="Thu nhập USD">
                            <span class="input__label-content input__label-content--juro">Thu nhập USD</span>
                        </label>
                    </span>
                    <span class="input input--isao">
                        <input class="input__field input__field--juro" type="text" id="txtRate" value="<%=ExchangeRate %>" />
                        <label class="input__label input__label--juro" for="txtRate" data-content="Tỉ giá">
                            <span class="input__label-content input__label-content--juro">Tỉ giá</span>
                        </label>
                    </span>
            </section>
            <section class="content bgcolor-8">
                    <span class="input input--isao">
                        <input class="input__field input__field--juro" type="text" id="txtPersonalReduction" value="9000000" />
                        <label class="input__label input__label--juro" for="txtPersonalReduction" data-content="Giảm trừ cá nhân">
                            <span class="input__label-content input__label-content--juro">Giảm trừ cá nhân</span>
                        </label>
                    </span>
                    <span class="input input--isao">
                        <input class="input__field input__field--juro" type="text" id="txtDependent" value="3600000" />
                        <label class="input__label input__label--juro" for="txtDependent" data-content="Người phụ thuộc">
                            <span class="input__label-content input__label-content--juro">Người phụ thuộc</span>
                        </label>
                    </span>
                    <span class="input input--isao">
                        <input class="input__field input__field--juro" type="text" id="txtNumOfDependent" value="0" />
                        <label class="input__label input__label--juro" for="txtNumOfDependent" data-content="Số người phụ thuộc">
                            <span class="input__label-content input__label-content--juro">Số người phụ thuộc</span>
                        </label>
                    </span>
                </section>
            <section class="nl-form">
				<form id="nl-form" class="nl-form">
                        Đóng bảo hiểm 
                        <select id="sel-option">
                            <option value="true" selected>trên lương chính thức.</option>
                            <option value="false">trên mức khác.</option>
                        </select>
                        <span id="spn-other" style="display: none;">
                        	Mức đóng bảo bảo hiểm của tôi là: 
							<input id="txtOther" type="text" value="" placeholder="mức đóng..." data-subline="Ví dụ: <em>20,000,000</em>" /> VND
                        </span>
						<br/>
						Lương tối thiểu vùng:
                        <select id="sel-minimum-salary">
                            <option value="3750000" selected>Vùng I (3,750,000 đồng/tháng).</option>
                            <option value="3320000">Vùng II (3,320,000 đồng/tháng).</option>
                            <option value="2900000">Vùng III (2,900,000 đồng/tháng).</option>
                            <option value="2580000">Vùng IV (2,580,000 đồng/tháng).</option>
                        </select>
                        Lương cơ sở: 
                        <input id="txtBasedSalary" type="text" value="1210000" placeholder="1210000" data-subline="Ví dụ: <em>1210000</em>"/> VND                      
                        <br/>
                        	Bảo hiểm xã hội
                            <input id="txSocialInsurance" type="text" value="8" placeholder="8" data-subline="Ví dụ: <em>8</em>"/>%.
                            Bảo hiểm y tế 
                            <input id="txtHealthInsurance" type="text" value="1.5" placeholder="1.5" data-subline="Ví dụ: <em>1.5</em>"/>%.
                            Bảo hiểm thất nghiệp
                            <input id="txtUnemployeeInsurance" type="text" value="1" placeholder="1" data-subline="Ví dụ: <em>1</em>"/>%.<br/>
                        <br/>
						<div class="nl-overlay"></div>
                </form>
				<script>
				    $(document).ready(function(e) {
				        $('#txtVnd').number(true, 2);
				        $('#txtUsd').number(true, 2);
				        $('#txtRate').number(true, 2);
				        $('#txtPersonalReduction').number(true, 0);
				        $('#txtDependent').number(true, 0);
				        $('#txtNumOfDependent').number(true, 0);
				    });
				</script>
                </section>
            <div class="btn-group">
                <button class="btn btn-6 btn-6c" id="gross2net">
                    GROSS sang NET</button>
                <button class="btn btn-6 btn-6c" id="net2gross">
                    NET sang GROSS</button>
            </div>
        </div>
        <nav id="bt-menu" class="bt-menu">
				<a href="#" class="bt-menu-trigger"><span>Menu</span></a>
				<ul>
					<li><a href="http://kiendang.com/cv/#about">About me</a></li>
					<li><a href="http://kiendang.com/cv/#experience">Work</a></li>
					<li><a href="http://kiendang.com/cv/#education">Education</a></li>
					<li><a href="http://kiendang.com/cv/#skills">Skills</a></li>
					<li><a href="http://kiendang.com/cv/#contact">Contact</a></li>
				</ul>
				<ul>
					<li><a href="https://plus.google.com/101095823814290637419" class="bt-icon icon-gplus">Google+</a></li>
					<li><a href="http://www.facebook.com/pages/Codrops/159107397912" class="bt-icon icon-facebook">Facebook</a></li>
				</ul>
			</nav>
    </div>
    <!-- /container -->
    <div class="details">
        <header class="codrops-header" style="padding: 1em 0;">
				<h1>Diễn giải chi tiết (VND)</h1>				
			</header>
        <div class="main">
            <table class="table-fill">
                <thead>
                    <tr>
                        <th class="text-right green column-details">
                            Diễn giải
                        </th>
                        <th class="text-right green">
                            Số tiền
                        </th>
                    </tr>
                </thead>
                <tbody class="table-hover">
                    <tr>
                        <td class="text-right td-important">
                            Lương GROSS
                        </td>
                        <td class="text-right td-important">
                            <span id="rstGross"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Bảo hiểm xã hội (<span id="uSocialPercentage">8</span>%)
                        </td>
                        <td class="text-right">
                            <span id="rstSocial"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Bảo hiểm y tế (<span id="uHealthPercentage">1.5</span>%)
                        </td>
                        <td class="text-right">
                            <span id="rstHealth"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Bảo hiểm thất nghiệp (<span id="uUnemployedPercentage">1</span>%)
                        </td>
                        <td class="text-right">
                            <span id="rstUnemployed"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right td-important">
                            Thu nhập trước thuế
                        </td>
                        <td class="text-right td-important">
                            <span id="rstBeforeTaxed"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Giảm trừ gia cảnh bản thân
                        </td>
                        <td class="text-right">
                            <span id="rstPersonal"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Giảm trừ gia cảnh người phụ thuộc
                        </td>
                        <td class="text-right">
                            <span id="rstDependant"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right td-important">
                            Thu nhập chịu thuế
                        </td>
                        <td class="text-right td-important">
                            <span id="rstTaxed"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Thuế thu nhập cá nhân <sup>(*)</sup>
                        </td>
                        <td class="text-right">
                            <span id="rstPit"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right td-important">
                            Lương NET
                        </td>
                        <td class="text-right td-important">
                            <span id="rstNet"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="details">
        <header class="codrops-header" style="padding: 1em 0;">
				<h1><sup>(*)</sup>Chi tiết thuế thu nhập cá nhân (VND)</h1>				
			</header>
        <div class="main">
            <table class="table-fill">
                <thead>
                    <tr>
                        <th class="text-right green column-tax-one">
                            Mức chịu thuế
                        </th>
                        <th class="text-right green column-tax-two">
                            Thuế suất
                        </th>
                        <th class="text-right green">
                            Tiền nộp
                        </th>
                    </tr>
                </thead>
                <tbody class="table-hover">
                    <tr>
                        <td class="text-right">
                            Đến 5 triệu VND
                        </td>
                        <td class="text-right">
                            5%
                        </td>
                        <td class="text-right">
                            <span id="r1"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Trên 5 triệu VND đến 10 triệu VND
                        </td>
                        <td class="text-right">
                            10%
                        </td>
                        <td class="text-right">
                            <span id="r2"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Trên 10 triệu VND đến 18 triệu VND
                        </td>
                        <td class="text-right">
                            15%
                        </td>
                        <td class="text-right">
                            <span id="r3"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Trên 18 triệu VND đến 32 triệu VND
                        </td>
                        <td class="text-right">
                            20%
                        </td>
                        <td class="text-right">
                            <span id="r4"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Trên 32 triệu VND đến 52 triệu VND
                        </td>
                        <td class="text-right">
                            25%
                        </td>
                        <td class="text-right">
                            <span id="r5"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Trên 52 triệu VND đến 80 triệu VND
                        </td>
                        <td class="text-right">
                            30%
                        </td>
                        <td class="text-right">
                            <span id="r6"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Trên 80 triệu VND
                        </td>
                        <td class="text-right">
                            35%
                        </td>
                        <td class="text-right">
                            <span id="r7"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="details">
        <header class="codrops-header" style="padding: 1em 0;">
				<h1>Người sử dụng lao động trả (VND)</h1>				
			</header>
        <div class="main">
            <table class="table-fill">
                <thead>
                    <tr>
                        <th class="text-right green column-details">
                            Diễn giải
                        </th>
                        <th class="text-right green">
                            Số tiền
                        </th>
                    </tr>
                </thead>
                <tbody class="table-hover">
                    <tr>
                        <td class="text-right">
                            Lương GROSS
                        </td>
                        <td class="text-right">
                            <span id="eGross"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Bảo hiểm xã hội (<span id="eSocialPercentage">18</span>%)
                        </td>
                        <td class="text-right">
                            <span id="eSocial"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Bảo hiểm y tế (<span id="eHealthPercentage">3</span>%)
                        </td>
                        <td class="text-right">
                            <span id="eHealth"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right">
                            Bảo hiểm thất nghiệp (<span id="eUnemployedPercentage">1</span>%)
                        </td>
                        <td class="text-right">
                            <span id="eUnemployed"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-right td-important">
                            Tổng cộng
                        </td>
                        <td class="text-right td-important">
                            <span id="eTotal"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script src="/js/classie.js"></script>

    <script src="/js/borderMenu.js"></script>

    <script src="/js/text-input.js"></script>

    <script>
        (function() {
            // trim polyfill : https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim
            if (!String.prototype.trim) {
                (function() {
                    // Make sure we trim BOM and NBSP
                    var rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;
                    String.prototype.trim = function() {
                        return this.replace(rtrim, '');
                    };
                })();
            }

            [ ].slice.call(document.querySelectorAll('input.input__field')).forEach(function(inputEl) {
                // in case the input is already filled..
                if (inputEl.value.trim() !== '') {
                    classie.add(inputEl.parentNode, 'input--filled');
                }

                // events:
                inputEl.addEventListener('focus', onInputFocus);
                inputEl.addEventListener('blur', onInputBlur);
            });

            function onInputFocus(ev) {
                classie.add(ev.target.parentNode, 'input--filled');
            }

            function onInputBlur(ev) {
                if (ev.target.value.trim() === '') {
                    classie.remove(ev.target.parentNode, 'input--filled');
                }
            }
        })();
    </script>

    <script src="/js/nlform.js"></script>

    <script>
        var nlform = new NLForm(document.getElementById('nl-form'));
    </script>

    <script type="text/javascript">
        $(document).ready(function() {
            $('#txtVnd').focusout(function() {
                $('#txtUsd').val(accounting.unformat(this.value) / accounting.unformat('<%=ExchangeRate %>'));
                $('#txtUsd').parent().addClass("input--filled");
            });
            $('#txtUsd').focusout(function() {
                $('#txtVnd').val(accounting.unformat(this.value) * accounting.unformat('<%=ExchangeRate %>'));
                $('#txtVnd').parent().addClass("input--filled");
            });

            var caculatorService = '<%=ResolveUrl("~/services/SalaryCaculatorService.asmx")%>';

            $('#gross2net').click(function() {
                var ajaxData = {
                    'income': $('#txtVnd').val(),
                    'personalReduction': $('#txtPersonalReduction').val(),
                    'dependant': $('#txtDependent').val(),
                    'numberOfDependant': $('#txtNumOfDependent').val(),
                    'isFullWage': $('#sel-option').val(),
                    'otherWage': $('#txtOther').val(),
                    'minimumAreaSalary': $('#sel-minimum-salary').val(),
                    'basedSalary': $('#txtBasedSalary').val(),
                    'socialInsurance': $('#txSocialInsurance').val(),
                    'healthInsurance': $('#txtHealthInsurance').val(),
                    'unemployedInsurance': $('#txtUnemployeeInsurance').val()
                };
                $.ajax({
                    type: 'POST',
                    url: caculatorService + '/GrossToNet',
                    data: JSON.stringify(ajaxData),
                    contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    success: function(result) {
                        console.log(result);
                        var resultObj = jQuery.parseJSON(result.d);

                        // detail
                        $('#rstGross').html(resultObj.gross);
                        $('#rstSocial').html(!resultObj.social ? 0 : resultObj.social);
                        $('#rstHealth').html(!resultObj.health ? 0 : resultObj.health);
                        $('#rstUnemployed').html(!resultObj.unemployed ? 0 : resultObj.unemployed);
                        $('#rstBeforeTaxed').html(resultObj.beforetaxed);
                        $('#rstPersonal').html(!resultObj.personal ? 0 : resultObj.personal);
                        $('#rstDependant').html(!resultObj.dependant ? 0 : resultObj.dependant);
                        $('#rstTaxed').html(!resultObj.taxedsalary ? 0 : resultObj.taxedsalary);
                        $('#rstPit').html(!resultObj.pit ? 0 : resultObj.pit);
                        $('#rstNet').html(resultObj.net);

                        // progressive
                        $('#r1').html(!resultObj.progressive.r1 ? 0 : resultObj.progressive.r1);
                        $('#r2').html(!resultObj.progressive.r2 ? 0 : resultObj.progressive.r2);
                        $('#r3').html(!resultObj.progressive.r3 ? 0 : resultObj.progressive.r3);
                        $('#r4').html(!resultObj.progressive.r4 ? 0 : resultObj.progressive.r4);
                        $('#r5').html(!resultObj.progressive.r5 ? 0 : resultObj.progressive.r5);
                        $('#r6').html(!resultObj.progressive.r6 ? 0 : resultObj.progressive.r6);
                        $('#r7').html(!resultObj.progressive.r7 ? 0 : resultObj.progressive.r7);

                        // employer
                        $('#eGross').html(resultObj.employer.gross);
                        $('#eSocial').html(!resultObj.employer.social ? 0 : resultObj.employer.social);
                        $('#eHealth').html(!resultObj.employer.health ? 0 : resultObj.employer.health);
                        $('#eUnemployed').html(!resultObj.employer.unemployed ? 0 : resultObj.employer.unemployed);
                        $('#eTotal').html(resultObj.employer.total);

                        // re-bind content
                        $('#uSocialPercentage').html(ajaxData.socialInsurance);
                        $('#uHealthPercentage').html(ajaxData.healthInsurance);
                        $('#uUnemployedPercentage').html(ajaxData.unemployedInsurance);

                        $('#eSocialPercentage').html(26 - ajaxData.socialInsurance);
                        $('#eHealthPercentage').html(4.5 - ajaxData.healthInsurance);
                        $('#eUnemployedPercentage').html(2 - ajaxData.unemployedInsurance);
                    }
                });
            });

            $('#net2gross').click(function() {
                var ajaxData = {
                    'incomeNet': $('#txtVnd').val(),
                    'personalReduction': $('#txtPersonalReduction').val(),
                    'dependant': $('#txtDependent').val(),
                    'numberOfDependant': $('#txtNumOfDependent').val(),
                    'isFullWage': $('#sel-option').val(),
                    'otherWage': $('#txtOther').val(),
                    'minimumAreaSalary': $('#sel-minimum-salary').val(),
                    'basedSalary': $('#txtBasedSalary').val(),
                    'socialInsurance': $('#txSocialInsurance').val(),
                    'healthInsurance': $('#txtHealthInsurance').val(),
                    'unemployedInsurance': $('#txtUnemployeeInsurance').val()
                };
                $.ajax({
                    type: 'POST',
                    url: caculatorService + '/NetToGross',
                    data: JSON.stringify(ajaxData),
                    contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    success: function(result) {
                        var resultObj = jQuery.parseJSON(result.d);

                        // detail
                        $('#rstGross').html(resultObj.gross);
                        $('#rstSocial').html(!resultObj.social ? 0 : resultObj.social);
                        $('#rstHealth').html(!resultObj.health ? 0 : resultObj.health);
                        $('#rstUnemployed').html(!resultObj.unemployed ? 0 : resultObj.unemployed);
                        $('#rstBeforeTaxed').html(resultObj.beforetaxed);
                        $('#rstPersonal').html(resultObj.personal);
                        $('#rstDependant').html(!resultObj.dependant ? 0 : resultObj.dependant);
                        $('#rstTaxed').html(resultObj.taxedsalary);
                        $('#rstPit').html(resultObj.pit);
                        $('#rstNet').html(resultObj.net);

                        // progressive
                        $('#r1').html(!resultObj.progressive.r1 ? 0 : resultObj.progressive.r1);
                        $('#r2').html(!resultObj.progressive.r2 ? 0 : resultObj.progressive.r2);
                        $('#r3').html(!resultObj.progressive.r3 ? 0 : resultObj.progressive.r3);
                        $('#r4').html(!resultObj.progressive.r4 ? 0 : resultObj.progressive.r4);
                        $('#r5').html(!resultObj.progressive.r5 ? 0 : resultObj.progressive.r5);
                        $('#r6').html(!resultObj.progressive.r6 ? 0 : resultObj.progressive.r6);
                        $('#r7').html(!resultObj.progressive.r7 ? 0 : resultObj.progressive.r7);

                        // employer
                        $('#eGross').html(resultObj.employer.gross);
                        $('#eSocial').html(!resultObj.employer.social ? 0 : resultObj.employer.social);
                        $('#eHealth').html(!resultObj.employer.health ? 0 : resultObj.employer.health);
                        $('#eUnemployed').html(!resultObj.employer.unemployed ? 0 : resultObj.employer.unemployed);
                        $('#eTotal').html(resultObj.employer.total);

                        // re-bind content
                        $('#uSocialPercentage').html(ajaxData.socialInsurance);
                        $('#uHealthPercentage').html(ajaxData.healthInsurance);
                        $('#uUnemployedPercentage').html(ajaxData.unemployedInsurance);

                        $('#eSocialPercentage').html(26 - ajaxData.socialInsurance);
                        $('#eHealthPercentage').html(4.5 - ajaxData.healthInsurance);
                        $('#eUnemployedPercentage').html(2 - ajaxData.unemployedInsurance);
                    }
                });
            });
        });
    </script>

</body>
</html>
