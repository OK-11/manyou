require 'rails_helper'

RSpec.describe 'step5', type: :system do

  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password') }
  let!(:admin) { User.create(name: 'admin_name', email: 'admin@email.com', password: 'password', admin: true) }
  let!(:task_created_by_user){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)}
  let!(:task_created_by_admin){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: admin.id)}
  let!(:label_created_by_user) { Label.create(name: 'label_name', user_id: user.id)}
  let!(:label_created_by_admin) { Label.create(name: 'label_name', user_id: admin.id)}

  describe '17.ラベルを1つ指定し検索することで、そのラベルが貼られたタスクのみ表示させること' do
    before do
      visit new_session_path
      sleep 0.5
      find('input[name="session[email]"]').set(user.email)
      find('input[name="session[password]"]').set(user.password)
      click_button 'ログイン'
      sleep 0.5
    end
    it 'ラベルを1つ指定し検索することで、そのラベルが貼られたタスクのみ表示させること' do
      5.times do |t|
        Task.create(title: "task_title_#{t+2}", content: "task_content_#{t+2}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
        task = Task.create(title: "task_title_#{t+7}", content: "task_content_#{t+7}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
        task.labels << label_created_by_user
      end
      visit tasks_path
      sleep 0.5
      find('select[name="search[label]"]').find("option[value='#{label_created_by_user.id}']").select_option
      click_button '検索'
      sleep 0.5
      expect(page).to have_content 'task_title_7'
      expect(page).to have_content 'task_title_8'
      expect(page).to have_content 'task_title_9'
      expect(page).to have_content 'task_title_10'
      expect(page).to have_content 'task_title_11'
      expect(page).not_to have_content 'task_title_2'
      expect(page).not_to have_content 'task_title_3'
      expect(page).not_to have_content 'task_title_4'
      expect(page).not_to have_content 'task_title_5'
      expect(page).not_to have_content 'task_title_6'
    end
  end
end
