# Copyright (c) 2010-2011 ProgressBound, Inc.
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class CreateCampaignStatements < ActiveRecord::Migration
  def self.up
    create_table :campaign_statements do |t|
      t.integer   :site_id
      t.date      :disbursed_on, :funds_available
      t.datetime  :starting, :ending
      t.decimal   :total_raised,  :precision => 8, :scale => 2, :default => 0
      t.decimal   :total_fees,    :precision => 8, :scale => 2, :default => 0
      t.decimal   :total_due,     :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
    
    add_index  :campaign_statements, :disbursed_on
    add_index  :campaign_statements, :site_id
    
    add_column :contributions, :campaign_statement_id, :integer
    add_index  :contributions, :campaign_statement_id
    add_column :contributions, :disbursed_on, :date
    add_index  :contributions, :disbursed_on
  end

  def self.down
    drop_table :campaign_statements
    remove_index  :contributions, :campaign_statement_id
    remove_column :contributions, :campaign_statement_id
  end
end
