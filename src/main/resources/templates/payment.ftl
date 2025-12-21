<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Methods</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            padding: 16px;
            color: #333;
            background-color: #fff;
        }

        .container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            padding: 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 {
            font-size: clamp(32px, 6vw, 48px);
            font-weight: bold;
            margin-bottom: 24px;
            text-align: center;
            width: 100%;
        }

        .bank-name {
            font-size: clamp(24px, 5vw, 36px);
            font-weight: bold;
            color: #1a73e8;
            margin: 24px 0 16px;
            text-align: center;
            width: 100%;
        }

        .qr-container {
            width: 100%;
            max-width: 400px;
            background-color: #f7f7f7;
            border-radius: 8px;
            padding: 16px;
            margin: 16px 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .qr-code {
            width: 100%;
            max-width: 300px;
            height: auto;
            display: block;
            margin: 0 auto;
        }

        .account-info {
            font-size: clamp(14px, 3vw, 16px);
            margin: 8px 0;
            font-weight: bold;
            text-align: center;
            width: 100%;
        }

        .momo-link {
            width: 100%;
            text-align: center;
            text-decoration: underline;
        }

        .momo-link-subtext {
            width: 100%;
            text-align: center;
            font-size: clamp(12px, 2vw, 14px);
            margin-bottom: 24px;
            margin-top: -10px;
        }

        @media screen and (max-width: 480px) {
            .container {
                padding: 8px;
            }

            .qr-container {
                padding: 12px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Payment methods</h1>
    <a href="https://me.momo.vn/8vI4iaiJuli2UmiOCmt7" target="_blank" class="momo-link">
        <div class="bank-name">Momo</div>
    </a>
    <div class="momo-link-subtext">(Click to open Momo App)</div>
    <div class="account-info">Phone Number: 0889838522</div>
    <div class="account-info">Name: PHAM HOANG PHUOC DUY</div>
    <div class="qr-container">
        <img src="/static/images/payment/momo_qr_code.jpg" alt="Momo QR Code" class="qr-code">
    </div>

    <div class="bank-name">MB Bank</div>
    <div class="account-info">STK: 1010125021999</div>
    <div class="account-info">Name: PHAM HOANG PHUOC DUY</div>
    <div class="qr-container">
        <img src="/static/images/payment/mb_bank_qr_code.jpg" alt="MB Bank QR Code" class="qr-code">
    </div>
</div>
</body>
</html>