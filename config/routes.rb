Rails.application.routes.draw do

    # Application Home
    root 'search#home'
    # Search Result page
    post 'result' => 'search#result'
    # For fetching results in ajax
    post 'ajax' => 'search#ajax'

end
