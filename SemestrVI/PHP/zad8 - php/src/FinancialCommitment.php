<?php

namespace FinancialCommitment;

use Money\Money;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;

class FinancialCommitment
{
    /**
     * @var UuidInterface
     */
    private $id;

    /**
     * @var Event[]
     */
    private $events = [];

    /**
     * @var Money
     */
    private $balance;

    // ... inne pola

    private $reader_id;
    private $cancelled;

    public function __construct(Money $amount, int $reader_id)
    {
        $this->id = Uuid::uuid4();
        $this->balance = $amount;
        $this->events[] = new Event\FinancialCommitmentCreated($amount);
        $this->reader_id = $reader_id;
        $this->cancelled = false;
    }

    public function registerPayment(Money $payment): void
    {
        $this->balance = $this->balance->subtract($payment);

        if ($this->balance->isZero()) {
            $this->events[] = new Event\FinancialCommitmentRepaid();
        } else if ($this->balance->isPositive()) {
            $this->events[] = new Event\FinancialCommitmentPartiallyPaid($payment);
        } else {
            $this->events[] = new Event\FinancialCommitmentOverpaid($this->balance->negative());
        }
    }

    protected function record(Event $event)
    {
        $this->events[] = $event;

        $this->apply($event);
    }

    protected function apply(Event $event)
    {
        switch (get_class($event)) {
            case Event\FinancialCommitmentCancelled::class:
                $this->balance = $this->balance->subtract($this->balance);
                $this->cancelled = true;

                break;
        }
    }

    public static function fromEvents(array $events): self
    {
        $object = new self();

        foreach ($events as $event) {
            $object->apply($event);
        }

        return $object;
    }

    public function cancel(): void
    {
        if ($this->isProcessed()()) {
            throw new Exception('Try to transform Commitment into illegal state');
        }

        $this->record(new Event\FinancialCommitmentCancelled());
    }

    public function getBalance(): Money
    {
        return $this->balance;
    }

    public function getEvents(): array
    {
        return $this->events;
    }

    public function getId(): UuidInterface
    {
        return $this->id;
    }

    private function isProcessed(): bool {
        return $this->balance->isNegative() || $this->balance->isNegative() || $this->cancelled;
    }
}
