# frozen_string_literal: true

class Zad1Controller < ApplicationController
  def typ1
    render html: "Hello"
  end

  def typ2
    render plain: "Hello"
  end

  def typ3
    @book = { id: 1, name: "The Book", author: "John Doe", price: 29.95, active: true }
    respond_to do |format|
      format.html do
      end
      format.xml do
        render xml: @book.to_xml
      end
    end
  end

  def typ4
    @book = { id: 1, name: "The Book", author: "John Doe", price: 29.95, active: true }
    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @book.to_json
      end
    end
  end
end
