#!/usr/bin/env python3
"""
Script to convert Task Warrior JSON export to iCalendar format (.ics)
This follows the format of a working iCalendar file from Apple Calendar
"""

import json
import sys
from datetime import datetime, timezone
import uuid


def task_to_ical(task_data, filename='taskwarrior_tasks.ics'):
    """
    Convert Task Warrior JSON data to iCalendar format based on working format
    """
    # Get current time for DTSTAMP
    current_time = datetime.now(timezone.utc)
    
    with open(filename, 'w', encoding='utf-8') as f:
        # Write calendar header
        f.write("BEGIN:VCALENDAR\n")
        f.write("CALSCALE:GREGORIAN\n")
        f.write("PRODID:-//Task Warrior Export//taskwarrior.org//\n")
        f.write("VERSION:2.0\n")
        f.write("X-APPLE-CALENDAR-COLOR:#4286F4\n")  # Blue color for Task Warrior calendar
        f.write("X-WR-CALNAME:Task Warrior\n")
        
        # Add timezone information
        f.write("BEGIN:VTIMEZONE\n")
        f.write("TZID:Asia/Shanghai\n")  # Using China timezone as in the example
        f.write("BEGIN:STANDARD\n")
        f.write("DTSTART:19890917T020000\n")
        f.write("RRULE:FREQ=YEARLY;UNTIL=19910914T170000Z;BYMONTH=9;BYDAY=3SU\n")
        f.write("TZNAME:GMT+8\n")
        f.write("TZOFFSETFROM:+0900\n")
        f.write("TZOFFSETTO:+0800\n")
        f.write("END:STANDARD\n")
        f.write("BEGIN:DAYLIGHT\n")
        f.write("DTSTART:19910414T020000\n")
        f.write("RDATE:19910414T020000\n")
        f.write("TZNAME:GMT+8\n")
        f.write("TZOFFSETFROM:+0800\n")
        f.write("TZOFFSETTO:+0900\n")
        f.write("END:DAYLIGHT\n")
        f.write("END:VTIMEZONE\n")
        
        # Process each task
        for task in task_data:
            # Only include pending tasks or tasks with future due dates
            task_status = task.get('status', 'pending')
            due_date = task.get('due', None)
            
            # Include pending tasks regardless of due date
            if task_status == 'pending':
                include_task = True
            elif task_status == 'completed' or task_status == 'deleted':
                # For completed/deleted tasks, only include if due date is in the future
                if due_date:
                    try:
                        due_dt = datetime.strptime(due_date, '%Y%m%dT%H%M%S%z')
                    except ValueError:
                        try:
                            due_dt = datetime.strptime(due_date, '%Y%m%dT%H%M%SZ')
                            # Assume UTC for naive datetime
                            due_dt = due_dt.replace(tzinfo=timezone.utc)
                        except ValueError:
                            # If date parsing fails, skip this task
                            continue
                    
                    include_task = due_dt >= current_time
                else:
                    # Completed tasks without due dates are not included
                    include_task = False
            else:
                # For any other status, include if due date is in the future
                if due_date:
                    try:
                        due_dt = datetime.strptime(due_date, '%Y%m%dT%H%M%S%z')
                    except ValueError:
                        try:
                            due_dt = datetime.strptime(due_date, '%Y%m%dT%H%M%SZ')
                            due_dt = due_dt.replace(tzinfo=timezone.utc)
                        except ValueError:
                            continue
                    
                    include_task = due_dt >= current_time
                else:
                    include_task = False
            
            if not include_task:
                continue
                
            # Write event
            f.write("BEGIN:VEVENT\n")
            
            # Set creation date
            entry_date = task.get('entry', None)
            if entry_date:
                try:
                    entry_dt = datetime.strptime(entry_date, '%Y%m%dT%H%M%S%z')
                except ValueError:
                    try:
                        entry_dt = datetime.strptime(entry_date, '%Y%m%dT%H%M%SZ')
                        entry_dt = entry_dt.replace(tzinfo=timezone.utc)
                    except ValueError:
                        entry_dt = current_time
                f.write(f"CREATED:{entry_dt.strftime('%Y%m%dT%H%M%S')}Z\n")
            
            # Add description if available
            annotations = task.get('annotations', [])
            if annotations:
                desc_parts = []
                for annotation in annotations:
                    entry_time = annotation.get('entry', '')
                    desc = annotation.get('description', '')
                    if entry_time and desc:
                        try:
                            annot_dt = datetime.strptime(entry_time, '%Y%m%dT%H%M%S%z')
                        except ValueError:
                            try:
                                annot_dt = datetime.strptime(entry_time, '%Y%m%dT%H%M%SZ')
                                annot_dt = annot_dt.replace(tzinfo=timezone.utc)
                            except ValueError:
                                annot_dt = current_time
                        desc_parts.append(f"[{annot_dt.strftime('%Y-%m-%d %H:%M')}] {desc}")
                if desc_parts:
                    # Properly format description with line breaks as per iCalendar spec
                    description = '\\n'.join(desc_parts)
                    # Wrap long lines according to iCalendar spec (75 chars max)
                    f.write("DESCRIPTION:")
                    line_pos = 12  # Length of "DESCRIPTION:"
                    words = description.split()
                    line = ""
                    for word in words:
                        if line_pos + len(word) <= 75:
                            line += word + " "
                            line_pos += len(word) + 1
                        else:
                            f.write(line.rstrip() + "\\n")
                            line = word + " "
                            line_pos = len(word) + 1
                    if line.strip():
                        f.write(line.rstrip())
                    f.write("\n")
            
            # Set due date if available (as DTSTART and DTEND)
            if due_date:
                try:
                    due_dt = datetime.strptime(due_date, '%Y%m%dT%H%M%S%z')
                except ValueError:
                    try:
                        due_dt = datetime.strptime(due_date, '%Y%m%dT%H%M%SZ')
                        due_dt = due_dt.replace(tzinfo=timezone.utc)
                    except ValueError:
                        due_dt = current_time
                
                # Format the date in the timezone format like the example
                f.write(f"DTEND;TZID=Asia/Shanghai:{due_dt.strftime('%Y%m%dT%H%M%S')}\n")
                f.write(f"DTSTART;TZID=Asia/Shanghai:{due_dt.strftime('%Y%m%dT%H%M%S')}\n")
            else:
                # If no due date, use a default future date
                default_dt = current_time.replace(year=current_time.year + 1)
                f.write(f"DTEND;TZID=Asia/Shanghai:{default_dt.strftime('%Y%m%dT%H%M%S')}\n")
                f.write(f"DTSTART;TZID=Asia/Shanghai:{default_dt.strftime('%Y%m%dT%H%M%S')}\n")
            
            # Write DTSTAMP
            f.write(f"DTSTAMP:{current_time.strftime('%Y%m%dT%H%M%S')}Z\n")
            
            # Set modification date
            modified_date = task.get('modified', entry_date)
            if modified_date:
                try:
                    mod_dt = datetime.strptime(modified_date, '%Y%m%dT%H%M%S%z')
                except ValueError:
                    try:
                        mod_dt = datetime.strptime(modified_date, '%Y%m%dT%H%M%SZ')
                        mod_dt = mod_dt.replace(tzinfo=timezone.utc)
                    except ValueError:
                        mod_dt = current_time
                f.write(f"LAST-MODIFIED:{mod_dt.strftime('%Y%m%dT%H%M%S')}Z\n")
            
            # Add sequence (for updates)
            f.write("SEQUENCE:0\n")
            
            # Set the task description as the event summary
            description = task.get('description', 'No description')
            # Properly escape special characters in summary
            summary = description.replace(',', '\\,').replace(';', '\\;').replace('\\', '\\\\')
            f.write(f"SUMMARY:{summary}\n")
            
            # Set transparency
            f.write("TRANSP:OPAQUE\n")
            
            # Set unique ID for the event
            task_uuid = task.get('uuid', str(uuid.uuid4()))
            f.write(f"UID:{task_uuid}\n")
            
            # Add status based on task status
            if task_status == 'completed':
                # For completed tasks, we'll add an alarm to indicate completion
                f.write("BEGIN:VALARM\n")
                f.write("ACTION:DISPLAY\n")
                f.write("DESCRIPTION:Task completed\n")
                f.write("TRIGGER:PT0S\n")
                alarm_uuid = str(uuid.uuid4()).upper()
                f.write(f"UID:{alarm_uuid}\n")
                f.write(f"X-WR-ALARMUID:{alarm_uuid}\n")
                f.write("END:VALARM\n")
            else:
                # For pending tasks, add a standard alarm
                f.write("BEGIN:VALARM\n")
                f.write("ACTION:DISPLAY\n")
                f.write("DESCRIPTION:Reminder\n")
                f.write("TRIGGER:PT0S\n")
                alarm_uuid = str(uuid.uuid4()).upper()
                f.write(f"UID:{alarm_uuid}\n")
                f.write(f"X-WR-ALARMUID:{alarm_uuid}\n")
                f.write("END:VALARM\n")
            
            f.write("END:VEVENT\n")
        
        f.write("END:VCALENDAR\n")
    
    print(f"Successfully converted {len([t for t in task_data if t.get('status', 'pending') == 'pending' or (t.get('due') and datetime.strptime(t.get('due', '20250101T000000Z'), '%Y%m%dT%H%M%S%z') if t.get('due', '').endswith('Z') else datetime.strptime(t.get('due', '20250101T000000'), '%Y%m%dT%H%M%S').replace(tzinfo=timezone.utc) >= current_time)])} tasks to {filename}")
    return filename


def main():
    if len(sys.argv) < 2:
        print("Usage: python task_to_ical_new.py <input_task_json_file> [output_ics_file]")
        print("Example: python task_to_ical_new.py taskwarrior_export.json taskwarrior_tasks_new.ics")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else 'taskwarrior_tasks_new.ics'
    
    try:
        with open(input_file, 'r') as f:
            task_data = json.load(f)
        
        if isinstance(task_data, dict) and 'data' in task_data:
            task_data = task_data['data']
        
        task_to_ical(task_data, output_file)
        print(f"Conversion complete! iCalendar file saved as: {output_file}")
        
    except FileNotFoundError:
        print(f"Error: Could not find input file {input_file}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON in file {input_file}")
        sys.exit(1)
    except Exception as e:
        print(f"Error during conversion: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
