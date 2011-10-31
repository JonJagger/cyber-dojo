<?php

require_once 'PHPUnit/Framework.php';
require_once 'PrimeFactors.php';

class PrimeFactorsTest extends PHPUnit_Framework_TestCase
{
    public function testAnswer()
    {
        $this->assertEquals(6 * 9, answer());
    }
}

?>
