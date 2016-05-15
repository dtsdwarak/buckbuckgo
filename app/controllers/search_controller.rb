class SearchController < ApplicationController

    rescue_from SocketError, with: :api_error

    def home
        word_count = Word.where(word:'vere').first
        puts word_count.count
    end

    def result
        require "duck_duck_go"
        search_param = params[:search_text]
        search_results = DuckDuckGo.new.zeroclickinfo(search_param)
        @hash = search_results.related_topics
        if (@hash.empty?)
            near_edits = calculate_words(search_param)
            @exist_words = Array.new
            for word in near_edits
                if (Word.exists?(word:word))
                    @exist_words << word
                end
            end
            @exist_words = @exist_words.uniq
        end
    end

    def ajax
        require "duck_duck_go"
        require "json"
        search_param = params[:search_text]
        search_results = DuckDuckGo.new.zeroclickinfo(search_param)
        hash = search_results.related_topics
        arr = Array.new
        hash.each do |key, array|
            array.each do |x|
                arr << "<a href='https://" + x.first_url.hostname + x.first_url.request_uri + "'>" + x.result[/(>\s*(.*?)\s*<)/,2] + "</a>"
            end
        end
        render :json => arr.first(7)
    end

    private

    def api_error
        flash[:notice] = "API Error. Try again from sometime."
        redirect_to "/"
    end

    # Calculate the words
    def calculate_words(word)

        # Split words
        splits = Array.new
        for i in 0..word.length
            splits << [word.slice(0,i), word.slice(i,word.length)]
        end

        # Deletes
        deletes = Array.new
        for arr in splits
            if !(arr[1].empty?)
                deletes << arr[0].to_s+arr[1][1..arr[1].length].to_s
            end
        end

        # Transposes
        transposes = Array.new
        for arr in splits
            if (arr[1].length>1)
                transposes << arr[0] + arr[1][1] + arr[1][0] + arr[1][2..arr[1].length]
            end
        end

        # Replaces
        alphabet = "abcdefghijklmnopqrstuvwxyz"
        replaces = Array.new
        for arr in splits
            alphabet.split("").each do |letter|
                if !(arr[1].empty?)
                    replaces << arr[0] + letter + arr[1][1..arr[1].length]
                end
            end
        end

        # Inserts
        inserts = Array.new
        for arr in splits
            alphabet.split("").each do |letter|
                inserts << arr[0] + letter + arr[1]
            end
        end

        return (deletes + transposes + replaces + inserts)
    end

end
