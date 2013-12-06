# Based on example code provided by Amazon
class FpsController < ApplicationController
  require 'aws/fps'
  require 'rexml/document'
  #require 'time'
  
  def redirect_to_amazon
    #render # let the user know what's going on before we get started
    get_caller_token
    get_recipient_token if @success
    #get_sender_token if @success # this step does nothing...
    redirect_to( get_amazon_url ) if @success
  end
  

  def thankyou
    @SenderTokenId = params['tokenID']
    @CallerTokenId = params['CallerTokenId']
    @RecipientTokenId = params['RecipientTokenId']
    @Amount = params['Amount']
    @success = true
    pay # these two steps are one in the same - we shouldn't be thanking the user unless the payment works!
    get_transaction # possibly not necessary, but probably a good idea.
    #todo: save details
  end 
  
  def index
    redirect_to '/'
  end
  
  private
  
  
  def get_unique
     Time.now.to_i.to_s + "-" + (1000 + rand(8999)).to_s
  end
  
  # functions that get called before sending the user to amazon

  def get_caller_token
    # generate a unique ID for this request
    unique_id = get_unique
    # prepare the REST request hash
    call = { 'Action' => 'InstallPaymentInstruction',
             'PaymentInstruction' => "MyRole == 'Caller' orSay 'Role does not match';",
             'CallerReference' => unique_id,
             'TokenType' => 'Unrestricted' }
    # make the REST call
    @success = false
		@fps_response = AWS::FPS::Query.do(call)
	  
		rexml_doc = REXML::Document.new(@fps_response)
		elements = rexml_doc.root.elements
    @xml_out = pretty_xml(rexml_doc)
		unless elements["Status"].nil?
		  @status = elements["Status"].text
      @request_id = elements["RequestId"].text
  		if @status == "Success"
  		  @success = true
  		  @CallerTokenId = elements["TokenId"].text
  		end
  	end
  end
      
  def get_recipient_token
    #@CallerTokenId = params['CallerTokenId']
    # generate a unique ID for this request
    unique_id = get_unique
    # prepare the REST request hash
    call = {'Action' => 'InstallPaymentInstruction',
      			'PaymentInstruction' => "MyRole == 'Recipient' orSay 'Roles do not match';",
      			'CallerReference' => unique_id,
      			'TokenType' => 'Unrestricted' }
    # make the REST call        
		@fps_response = AWS::FPS::Query.do(call)
		rexml_doc = REXML::Document.new(@fps_response)
		elements = rexml_doc.root.elements
    @xml_out = pretty_xml(rexml_doc)
		@status = elements["Status"].text
		@request_id = elements["RequestId"].text
		@success = false
		if @status == "Success"
		  @success = true
		  @RecipientTokenId = elements["TokenId"].text
		end
  end
  
  #def get_sender_token
  #  @CallerTokenId = params['CallerTokenId']
  #  @RecipientTokenId = params['RecipientTokenId']
  #end

  def get_amazon_url
    # generate a unique ID for this request
    unique_id = get_unique #Time.now.to_i.to_s # you might use some other 128 character string (db unique id...?)

    # params for the Amazon Payments Co-branded Pipeline redirect
		cbui_params = { 'transactionAmount' => params['amount'],
		                'pipelineName' => 'MultiUse', # Singe, Multi, Recuring
  		              'paymentReason' => 'Test Payment',
  		              'callerReference' => 'SenderToken-' + unique_id }

    # params for the return URL - the page that is opened after the token request is processed. 
    return_params = { 'Amount' => params['amount'],
                      'CallerTokenId' => @CallerTokenId, # unquoted and @'d
                      'RecipientTokenId' => @RecipientTokenId } 
    return_path = "fps/thankyou" # thank you controller/method
    
    cbui_URL = AWS::FPS::CBUI.make_url(cbui_params, return_params, return_path)
    logger.info(cbui_URL)
    return cbui_URL
  end
  
  # functions that get called after the user returns from amaxon
  
  def pay
    #@CallerTokenId = params['CallerTokenId']
    #@RecipientTokenId = params['RecipientTokenId']
    #@SenderTokenId = params['SenderTokenId']
    #@Amount = params['Amount']

    call = {  'Action' => 'Pay',
          		# tokens
          		'CallerTokenId' => @CallerTokenId,
          		'SenderTokenId' => @SenderTokenId,
          		'RecipientTokenId' => @RecipientTokenId,
		
          		# transactions details ### NOTE: Complex types are sent like this. #####
          		'TransactionAmount.Amount' => @Amount, 
          		'TransactionAmount.CurrencyCode' => 'USD', 
          		'TransactionDate' => Time.now.gmtime.iso8601, # example result: 2007-05-10T13:08:02
          		'ChargeFeeTo' => 'Recipient', #this must match the true/false value from the recipient token
		
          		# references - unique transaction values
          		'CallerReference' => 'Order-' + Time.now.to_i.to_s, # required unique value for each pay call
          		'SenderReference' => 'Test Sender reference string', # optional unique reference for the sender
          		'RecipientReference' => 'Test Recipient reference string' # optional unique reference for the recipient
          }
    # make the REST call        
		@fps_response = AWS::FPS::Query.do(call)
		rexml_doc = REXML::Document.new(@fps_response)
		elements = rexml_doc.root.elements
    @xml_out = pretty_xml(rexml_doc)
		@status = elements["Status"].text
		@request_id = elements["RequestId"].text
		@success = false
		if @status == "Success"
		  @success = true
		  @TransactionId = elements["TransactionResponse"].elements['TransactionId'].text
		end
  end
  
  def get_transaction
     #@TransactionId = params['TransactionId']
     call = {  
            'Action' => 'GetTransaction',
            'TransactionId' => @TransactionId 
            }
    # make the REST call        
		@fps_response = AWS::FPS::Query.do(call)
		rexml_doc = REXML::Document.new(@fps_response)
		elements = rexml_doc.root.elements
    @xml_out = pretty_xml(rexml_doc)
		@status = elements["Status"].text
		@request_id = elements["RequestId"].text
		@success = false
		if @status == "Success"
		  @success = true
		end
  end
  
  def pretty_xml(rexml_doc)
  	xml_out = String.new
    rexml_doc.write(xml_out, 1, false,true) 
    xml_out = REXML::Text.new(xml_out,true).to_s
  end
  
end
