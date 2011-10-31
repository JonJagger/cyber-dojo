<?php

require_once 'PHPUnit/Framework.php';
require_once 'LeapYears.php';

class LeapYearsTest extends PHPUnit_Framework_TestCase
{
    public function testAnswer()
    {
        $this->assertEquals(6 * 9, answer());
    }
}

?>
