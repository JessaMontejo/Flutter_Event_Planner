<?php

require "connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
   
    $response = array();
    $eventnow = $_POST['eventnow'];
    $pax = $_POST['pax'];
    $venue = $_POST['venue'];
    $trans_dt = $_POST['trans_dt'];
    $clientid = $_POST['clientid'];


    $insert = "UPDATE tbl_events SET eventnow ='$eventnow',pax ='$pax', venue = '$venue',trans_dt = '$trans_dt' WHERE id='$clientid'";
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