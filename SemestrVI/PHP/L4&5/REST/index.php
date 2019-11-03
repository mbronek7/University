<?php

use Slim\Http\Request;
use Slim\Http\Response;

require 'vendor/autoload.php';

$app = new Slim\App;

$serializer= new App\AccountSerializer;

$app->get('/accounts', function (Request $request, Response $response, array $args) use ($serializer) {
    //echo json_encode($serializer->getAll());
    return $response->withJson($serializer->getAll());
});

$app->get('/accounts/{id}', function (Request $request, Response $response, array $args) use ($serializer) {
    $id = $args['id'];
    return $response->withJson($serializer->get($id));
});

$app->post('/accounts', function(Request $request, Response $response, array $args) use ($serializer) {
    $fields = $request->getParsedBody();
    $account = $serializer->add($fields);
    return $response->withJson($account);
});

$app->post('/accounts/{id}/updateStatus', function(Request $request, Response $response, array $args) use ($serializer) {
    $id = $args['id'];
    $status = $request->getParsedBody()['status'];
    return $response->withJson($serializer->update($id, ['status' => $status]));
});

$app->post('/accounts/{id}/addPoints', function(Request $request, Response $response, array $args) use ($serializer) {
    $id = $args['id'];
    $points = $request->getParsedBody()['points'];
    return $response->withJson($serializer->addPoints($id, $points));
});

$app->run();
