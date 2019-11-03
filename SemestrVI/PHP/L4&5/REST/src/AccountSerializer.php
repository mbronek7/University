<?php


namespace App;


class AccountSerializer
{
    private $currentID;
    private $accountsById;

    public function __construct()
    {
        $this->currentID = 0;
        $this->accountsById = [];
    }

    public function getAll(): array
    {
        return $this->accountsById;
    }

    public function get(int $id): Account
    {
        return $this->accountsById[$id];
    }

    public function add(array $fields): Account
    {
        $id = $this->currentID + 1;

        $new = new Account;
        $new->id = $id;
        $new->email = $fields['email'];
        $new->description = $fields['description'];
        $new->points = $fields['points'];
        $new->status = $fields['status'];

        $this->currentID++;
        array_push($this->accountsById, $new);
        //echo json_encode($this->accountsById);
        return $new;
    }

    public function update(int $id, array $fields): Account
    {
        $account =& $this->accountsById[$id];
        foreach ($fields as $name => $value) {
            $account->$name = $value;
        }
        return $account;
    }

    public function addPoints(int $id, int $points): Account
    {
        $account =& $this->accountsById[$id];
        $account->points += $points;
        return $account;
    }
}
