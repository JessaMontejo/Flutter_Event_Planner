<?php

require "connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    $data = json_decode(file_get_contents('php://input'), true);
    $response = array();
    $eventnow = $data['eventnow'];
    $pax = $data['pax'];
    $venue = $data['venue'];
    $trans_dt = $data['trans_dt'];
    $clientid = $data['clientid'];


    $insert ="INSERT INTO tbl_events VALUE(NULL,'$eventnow','$pax','$venue','$trans_dt','$clientid')";
    if (mysqli_query($con,$insert))
    {
        $response['value'] = 1;
        $response['message'] = "Record Successfully";
        echo json_encode($response);
    }
    else
    {
        $response['value'] = 0;
        $response['message'] = "Record Failed";
        echo json_encode($response);
    }
     
    
    

  
   
 
}

?>