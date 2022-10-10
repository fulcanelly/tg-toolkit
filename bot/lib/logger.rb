require 'logger'

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG


def logger 
    $logger
end
