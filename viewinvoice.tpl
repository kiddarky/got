<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <title>{$companyname} - {$pagetitle}</title>

    <link href="{assetPath file='all.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{assetPath file='theme.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/css/fontawesome-all.min.css" rel="stylesheet">
    <link href="{assetPath file='invoice.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="/templates/{$template}/statics/css/css.css" rel="stylesheet">
    <script>var whmcsBaseUrl = "{$WEB_ROOT}";</script>
    <script src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>

</head>
<body class="viewinvoice-page">

    {include file="$template/includes/page-head.tpl"}

    {include file="$template/includes/page-left-nav.tpl"}

    <div class="page-right" id="main-body">
        <div class="container-fluid">
            <div class="primary-content">
                <div class="page-title">VIEW INVOICE</div>
                {if $invalidInvoiceIdRequested}

                {include file="$template/includes/panel.tpl" type="danger" headerTitle="{lang key='error'}" bodyContent="{lang key='invoiceserror'}" bodyTextCenter=true}

                {else}
                <div class="panel panel-default viewinvoice-panel">
                    <div class="panel-body">
                        {if $paymentSuccessAwaitingNotification}
                            {include file="$template/includes/panel.tpl" type="success" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicePaymentSuccessAwaitingNotify'}" bodyTextCenter=true}
                        {elseif $paymentSuccess}
                            {include file="$template/includes/panel.tpl" type="success" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicepaymentsuccessconfirmation'}" bodyTextCenter=true}
                        {elseif $paymentInititated}
                            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicePaymentInitiated'}" bodyTextCenter=true}
                        {elseif $pendingReview}
                            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicepaymentpendingreview'}" bodyTextCenter=true}
                        {elseif $paymentFailed}
                            {include file="$template/includes/panel.tpl" type="danger" headerTitle="{lang key='error'}" bodyContent="{lang key='invoicepaymentfailedconfirmation'}" bodyTextCenter=true}
                        {elseif $offlineReview}
                            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='success'}" bodyContent="{lang key='invoiceofflinepaid'}" bodyTextCenter=true}
                        {/if}
                        <div class="invoiced-pay-block">
                            <div class="left">
                                <div class="title">INVOICED TO</div>
                                <div class="content">
                                    {if $clientsdetails.companyname}{$clientsdetails.companyname}<br />{/if}
                                    {$clientsdetails.firstname} {$clientsdetails.lastname}<br />
                                    {$clientsdetails.address1}, {$clientsdetails.address2}<br />
                                    {$clientsdetails.city}, {$clientsdetails.state}, {$clientsdetails.postcode}<br />
                                    {$clientsdetails.country}
                                    {if $clientsdetails.tax_id}
                                        <br />{$taxIdLabel}: {$clientsdetails.tax_id}
                                    {/if}
                                    {if $customfields}
                                        <br /><br />
                                        {foreach $customfields as $customfield}
                                            {$customfield.fieldname}: {$customfield.value}<br />
                                        {/foreach}
                                    {/if}

                                    <br/><br/>
                                    <b>INVOICE DATE</b><br/>
                                    {$date}
                                </div>
                            </div>
                            <div class="right">
                                <div class="title">PAY TO</div>
                                <div class="content">
                                    <div class="qr">
                                        <!--<img src="statics/images/pages/viewinvoice/paycode.png"/>-->
                                        <!--{$payto}-->
                                        {if $taxCode}<br />{$taxIdLabel}: {$taxCode}{/if}
                                    </div>
                                    <div class="text-center">
                                        <p>Payment Method: {$availableGateways[$selectedGateway]}</p>
                                    </div>
                                    {if $status eq "Unpaid" || $status eq "Draft"}
                                        <div class="text-center">
                                            {$paymentbutton}
                                        </div>
                                        <div class="text-center">
                                            {lang key='invoicesdatedue'}: {$datedue}
                                        </div>
                                    {/if}
                                </div>
                            </div>
                        </div>
                        <div class="invoice-block">
                            <div class="title">
                                <div>INVOICE ITEMS</div>
                                <div>SUB TOTAL</div>
                            </div>
                            <div class="invoice-items">
                                {foreach $invoiceitems as $item}
                                <div class="invoice-row">
                                    <div class="info">
                                        {$item.description}{if $item.taxed eq "true"} *{/if}
                                    </div>
                                    <div class="total">
                                        <div class="col"></div>
                                        <div class="col"></div>
                                        <div class="col"><span>{$item.amount}</span></div>
                                    </div>
                                </div>
                                {/foreach}
                            </div>
                            <div class="total-money">
                                {if $status eq "Draft"}
                                    <div class="status draft">{lang key='invoicesdraft'}</div>
                                {elseif $status eq "Unpaid"}
                                    <div class="status unpaid">{lang key='invoicesunpaid'}</div>
                                {elseif $status eq "Paid"}
                                    <div class="status paid">{lang key='invoicespaid'}</div>
                                {elseif $status eq "Refunded"}
                                    <div class="status refunded">{lang key='invoicesrefunded'}</div>
                                {elseif $status eq "Cancelled"}
                                    <div class="status cancelled">{lang key='invoicescancelled'}</div>
                                {elseif $status eq "Collections"}
                                    <div class="status collections">{lang key='invoicescollections'}</div>
                                {elseif $status eq "Payment Pending"}
                                    <div class="status paid">{lang key='invoicesPaymentPending'}</div>
                                {/if}

                                <div class="right">
                                    <div class="col"></div>
                                    <div class="col">
                                        <div>SUB TOTAL</div>
                                        {if $taxname}
                                            {$taxrate}% {$taxname}
                                        {/if}
                                        {if $taxname2}
                                            {$taxrate2}% {$taxname2}
                                        {/if}
                                        <div>CREDIT</div>
                                        <div>TOTAL</div>
                                    </div>
                                    <div class="col money">
                                        <div>{$subtotal}</div>
                                        {if $taxname}
                                            {$tax}
                                        {/if}
                                        {if $taxname2}
                                            {$tax2}
                                        {/if}
                                        <div>{$credit}</div>
                                        <div>{$total}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {if $taxrate}
                            <p>* {lang key='invoicestaxindicator'}</p>
                        {/if}
                        <table class="table text-center transaction-block">
                            <thead>
                            <tr>
                                <th class="text-center" style="width: 25%;">TRANSACTION DATE</th>
                                <th class="text-center" style="width: 25%;">GATEWAY</th>
                                <th class="text-center" style="width: 25%;">TRANSACTION ID</th>
                                <th class="text-center" style="width: 25%;">AMOUNT</th>
                            </tr>
                            </thead>
                            <tbody>
                            {foreach $transactions as $transaction}
                                <tr>
                                    <td class="text-center">{$transaction.date}</td>
                                    <td class="text-center">{$transaction.gateway}</td>
                                    <td class="text-center">{$transaction.transid}</td>
                                    <td class="text-center">{$transaction.amount}</td>
                                </tr>
                                {foreachelse}
                                <tr>
                                    <td class="text-center" colspan="4">{lang key='invoicestransnonefound'}</td>
                                </tr>
                            {/foreach}
                            </tbody>
                        </table>
                        <div class="balance-block">Balance&emsp;&emsp;{$balance}</div>
                    </div>
                </div>
                {/if}
            </div>
        </div>
    </div>

    <div id="fullpage-overlay" class="w-hidden">
        <div class="outer-wrapper">
            <div class="inner-wrapper">
                <img src="{$WEB_ROOT}/assets/img/overlay-spinner.svg" alt="">
                <br>
                <span class="msg"></span>
            </div>
        </div>
    </div>

</body>
</html>
