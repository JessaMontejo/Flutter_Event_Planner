<?php

require "connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){

    $response = array();
    $username = $_POST['username'];
    $password = $_POST['password'];
    $email = $_POST['email'];
   


    
    $check = "SELECT * FROM tbl_users WHERE username='$username'";
    $result = mysqli_fetch_array(mysqli_query($con,$check));

    if (isset($result)) 
    {
        $response['value']=2;
        $response['message'] = "Username already exist";
        echo json_encode($response);
    } 
    else
    {
        $insert = "INSERT INTO tbl_users VALUE(NULL,'$username','$password','$email')";
        if (mysqli_query($con,$insert))
        {
            $response['value'] = 1;
            $response['message'] = "Registered Successfully";
            echo json_encode($response);
        }
        else
        {
            $response['value'] = 0;
            $response['message'] = "Registration Failed";
            echo json_encode($response);
        }
     
    }
    

  
   
 
}

?>