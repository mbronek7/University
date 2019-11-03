<?php

namespace FinancialCommitment\Commands;

use FinancialCommitment\Event;
use Money\Money;

class FinancialCommitmentOverpaid extends Event
{
    private $overpayment;

    public function __construct(Money $overpayment)
    {
        parent::__construct();
        $this->overpayment = $overpayment;
    }

    public function getOverpayment(): Money
    {
        return $this->overpayment;
    }
}
