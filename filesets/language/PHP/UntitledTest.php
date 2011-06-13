<?php

require_once 'PHPUnit/Framework.php';
require_once 'Untitled.php';

class UntitledTest extends PHPUnit_Framework_TestCase
{
    public function testAnswer()
    {
        $this->assertEquals(9 * 6, answer());
    }
}

?>
